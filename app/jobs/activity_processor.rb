class ActivityProcessor
  include Sidekiq::Worker

  def perform(activity)
    activity = JSON.parse(activity)
    actor = activity.dig("actor", "name")

    actor = User.find_by(username: actor)
    content = activity.dig("object", "content")
    published = activity["published"]

    actor.sent_messages.create!(
      created_at: published,
      content: content,
      to: Array.wrap(activity["to"])
    )

    message = {
      created_at: published,
      from_id: actor.id,
      content: content,
    }

    FanoutMessageWorker.perform_async(actor.id, message)
  end
end
