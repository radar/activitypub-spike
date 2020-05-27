class FanoutMessageWorker
  include Sidekiq::Worker

  def perform(actor_id, message)
    actor = User.find(actor_id)

    actor.followers.find_each do |follower|
      ReceiveMessageWorker.perform_async(follower.id, actor.id, message)
    end
  end
end
