class ActivityProcessor
  include Sidekiq::Worker

  def perform(activity)
    activity = Activity.new(JSON.parse(activity))

    case activity.type
    when "Create"
      handle_create_activity(activity)
    when "Update"
      handle_update_activity(activity)
    end
  end

  def handle_create_activity(activity)
    actor = User.find_by(username: activity.actor_name)
    content = activity.object.content
    published = activity.published

    source = actor.sent_messages.create!(
      created_at: published,
      content: content,
      to: activity.to,
    )

    message = {
      created_at: published,
      from_id: actor.id,
      content: content,
    }

    FanoutMessageWorker.perform_async(actor.id, source.id, message)
  end

  def handle_update_activity(activity)
    actor = User.find_by(username: activity.actor_name)
    content = activity.object.content
    updated_at = activity.published

    sent_message = GlobalID::Locator.locate(activity.object.id)
    return if sent_message.from != actor

    sent_message.update(
      updated_at: updated_at,
      content: content,
    )

    FanoutUpdateMessageWorker.perform_async(actor.id, activity.object.id, content, updated_at)
  end
end
