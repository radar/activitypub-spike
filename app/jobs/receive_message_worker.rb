class ReceiveMessageWorker
  include Sidekiq::Worker

  def perform(follower_id, actor_id, message)
    ReceivedMessage.create!(
      message.merge(
        from_id: actor_id,
        to_id: follower_id,
      )
    )
  end
end
