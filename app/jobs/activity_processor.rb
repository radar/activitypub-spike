class ActivityProcessor
  include Sidekiq::Worker

  def perform(activity)
    activity = Activity.new(JSON.parse(activity))

    actor = User.find_by(username: activity.actor_name)
    content = activity.object.content
    published = activity.published

    actor.sent_messages.create!(
      created_at: published,
      content: content,
      to: activity.to,
    )

    message = {
      created_at: published,
      from_id: actor.id,
      content: content,
    }

    FanoutMessageWorker.perform_async(actor.id, message)
  end
end
