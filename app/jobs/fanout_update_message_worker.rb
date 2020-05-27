class FanoutUpdateMessageWorker
  include Sidekiq::Worker

  def perform(actor_id, sent_message_id, content, updated_at)
    actor = User.find(actor_id)
    sent_message = GlobalID::Locator.locate(sent_message_id)

    sent_message.delivered_messages.find_each do |message|
      message.update(
        content: content,
        updated_at: updated_at,
      )
    end
  end
end
