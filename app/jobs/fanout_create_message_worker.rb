
class FanoutCreateMessageWorker
  include Sidekiq::Worker

  PUBLIC_ADDRESS = "https://www.w3.org/ns/activitystreams#Public"

  def perform(to, actor_id, source_id, message)
    actor = Actor.find(actor_id)

    if to.include?(actor.followers_url)
      actor.followers.find_each do |follower|
        ReceiveMessageWorker.perform_async(source_id, follower.id, actor_id, message)
      end
    end

    (to - [actor.followers_url, PUBLIC_ADDRESS]).each do |to_address|
      receiver = GlobalID::Locator.locate(to_address)
      ReceiveMessageWorker.perform_async(source_id, receiver.id, actor_id, message)
    end
  end
end
