class FanoutCreateMessageWorker
  include Sidekiq::Worker

  PUBLIC_ADDRESS = "https://www.w3.org/ns/activitystreams#Public"

  def perform(to, actor_id, source_id, message)
    actor = User.find(actor_id)

    to = Array.wrap(to)

    if to.include?(PUBLIC_ADDRESS)
      actor.followers.find_each do |follower|
        ReceiveMessageWorker.perform_async(source_id, follower.id, actor_id, message)
      end

      to.delete(PUBLIC_ADDRESS)
    end

    to.each do |to_address|
      receiver = GlobalID::Locator.locate(to_address)
      ReceiveMessageWorker.perform_async(source_id, receiver.id, actor_id, message)
    end
  end
end
