class FanoutMessageWorker
  include Sidekiq::Worker

  def perform(actor_id, source_id, message)
    actor = User.find(actor_id)

    actor.followers.find_each do |follower|
      ReceiveMessageWorker.perform_async(source_id, follower.id, actor.id, message)
    end
  end
end
