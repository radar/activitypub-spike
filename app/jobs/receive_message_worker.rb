class ReceiveMessageWorker
  include Sidekiq::Worker

  def perform(source_id, follower_id, actor_id, message)
    ReceivedMessage.create!(
      message.merge(
        source_id: source_id,
        to_id: follower_id,
        from_id: actor_id,
      )
    )
  end
end
