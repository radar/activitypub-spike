require 'rails_helper'

RSpec.describe 'POST /:user/outbox, Update Activity' do
  def post_message
    headers = { "Content-Type" => "application/json" }
    post "/radar/outbox", params: { activity: activity }.to_json, headers: headers
  end

  context "with a valid activity" do
    let(:radar) { FactoryBot.create(:actor, username: "radar") }
    let(:mdhoad) { FactoryBot.create(:actor, username: "mdhoad") }
    let!(:sent_message) { FactoryBot.create(:sent_message, from: radar, content: "to be updated") }
    let!(:received_message) do
      FactoryBot.create(:received_message, source: sent_message, from: radar, to: mdhoad, content: "to be updated")
    end

    let(:published) { Time.current }
    let(:new_content) { "This is the new content for the message" }

    let(:activity) do
      {
        "@context": "https://www.w3.org/ns/activitystreams",
        "summary": "Radar updated a message",
        "type": "Update",
        "actor": {
          "type": "User",
          "name": "#{actor}",
        },
        "object": {
          "id": sent_message.to_global_id.to_s,
          "type": "Message",
          "content": new_content,
        },
        "published": published,
        "to": "https://www.w3.org/ns/activitystreams#Public",
      }
    end

    context "when the user owns the message" do
      let(:actor) { "radar" }

      it "updates the existing message" do
        post_message

        expect(radar.sent_messages.count).to eq(1)
        sent_message = radar.sent_messages.first
        expect(sent_message.content).to eq(new_content)

        expect(mdhoad.received_messages.count).to eq(1)
        received_message = mdhoad.received_messages.first
        expect(received_message.content).to eq(new_content)
      end
    end

    context "when the user does not own the message" do
      let(:actor) { "mdhoad" }
      it "the message is not updated" do
        post_message

        expect(radar.sent_messages.count).to eq(1)
        sent_message = radar.sent_messages.first
        expect(sent_message.content).to eq("to be updated")

        expect(mdhoad.received_messages.count).to eq(1)
        received_message = mdhoad.received_messages.first
        expect(received_message.content).to eq("to be updated")
      end
    end
  end
end
