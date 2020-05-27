require 'rails_helper'

RSpec.describe 'POST /:user/outbox, Create Activity' do
  def post_message
    headers = { "Content-Type" => "application/json" }
    post "/radar/outbox", params: { activity: activity }.to_json, headers: headers
  end

  context "with a valid activity" do
    let(:radar) { FactoryBot.create(:user, username: "radar") }
    let(:mdhoad) { FactoryBot.create(:user, username: "mdhoad") }
    let(:sharon) { FactoryBot.create(:user, username: "sharon") }

    before do
      radar.followers << mdhoad
      radar.followers << sharon
    end

    let(:published) { Time.current }
    let(:actor) { "radar" }

    let(:activity) do
      # Example 15: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-create
      {
        "@context": "https://www.w3.org/ns/activitystreams",
        "summary": "Radar created a note",
        "type": "Create",
        "actor": {
          "type": "User",
          "name": "#{actor}",
        },
        "object": {
          "type": "Message",
          "content": "This is a simple message"
        },
        "published": published,
        "to": "https://www.w3.org/ns/activitystreams#Public",
      }
    end

    it "sends a message to radar's followers" do
      post_message

      expect(response).to have_http_status(200)

      expect(radar.sent_messages.count).to eq(1)
      expect(mdhoad.received_messages.count).to eq(1)
      expect(sharon.received_messages.count).to eq(1)
    end

    it "takes into account a message's published time" do
      post_message

      expect(radar.sent_messages.first.created_at).to be_within(0.01).of(published)
    end

    context "handles case where actor does not exist" do
      let(:actor) { "ella" }

      it "returns a 404" do
        post_message

        expect(response.status).to eq(404)
      end
    end
  end

  context "with an unwrapped message" do
    let(:radar) { FactoryBot.create(:user, username: "radar") }
    let(:mdhoad) { FactoryBot.create(:user, username: "mdhoad") }

    let(:activity) do
      # Example 2: https://www.w3.org/TR/activitypub/#create-activity-outbox
      {
        "@context": "https://www.w3.org/ns/activitystreams",
        "type": "Message",
        "to": [mdhoad.to_global_id.to_s],
        "attributedTo": radar.to_global_id.to_s,
        "content": "Say, did you finish reading that book I lent you?",
      }
    end

    it "sends a message from radar to mdhoad" do
      post_message
      expect(response).to have_http_status(200)

      expect(radar.sent_messages.count).to eq(1)
      expect(mdhoad.received_messages.count).to eq(1)
    end
  end

  context "handles malformed activities" do
    context "with missing @context and actor" do
      let(:activity) do
        {
          "summary": "Sally created a note",
          "type": "Create",
          "object": {
            "type": "Message",
            "content": "This is a simple message"
          },
          "to": "https://www.w3.org/ns/activitystreams#Public",
        }
      end

      it "returns a 422, with errors" do
        post_message

        expect(response.status).to eq(422)
        errors = JSON.parse(response.body)
        expect(errors["@context"]).to eq(["@context is missing"])
        expect(errors["actor"]).to eq(["actor is missing"])
      end
    end
  end
end
