require 'rails_helper'

# The Delete activity is used to delete an already existing object. The side effect 
# of this is that the server MAY replace the object with a Tombstone of the object 
# that will be displayed in activities which reference the deleted object. If the 
# deleted object is requested the server SHOULD respond with either the HTTP 410 
# Gone status code if a Tombstone object is presented as the response body, 
# otherwise respond with a HTTP 404 Not Found.
# https://www.w3.org/TR/activitypub/#delete-activity-outbox
# {
#   "@context": "https://www.w3.org/ns/activitystreams",
#   "id": "https://example.com/~alice/note/72",
#   "type": "Tombstone",
#   "published": "2015-02-10T15:04:55Z",
#   "updated": "2015-02-10T15:04:55Z",
#   "deleted": "2015-02-10T15:04:55Z"
# }

RSpec.describe 'POST /:user/outbox, Delete Activity' do
  def post_message
    headers = { "Content-Type" => "application/json" }
    post "/radar/outbox", params: { activity: activity }.to_json, headers: headers
  end

  context "with a valid activity" do
    let(:radar) { FactoryBot.create(:user, username: "radar") }
    let(:mdhoad) { FactoryBot.create(:user, username: "mdhoad") }
    let!(:sent_message) { FactoryBot.create(:sent_message, from: radar, content: "to be deleted") }
    let!(:received_message) do
      FactoryBot.create(:received_message, source: sent_message, from: radar, to: mdhoad, content: "to be deleted")
    end

    let(:published) { Time.current }

    let(:activity) do
      {
        "@context": "https://www.w3.org/ns/activitystreams",
        "summary": "#{actor} removed a note from her notes folder",
        "type": "Delete",
        "actor": {
          "type": "Person",
          "name": "#{actor}"
        },
        "object": "#{sent_message.to_global_id.to_s}",
        "target": {
          "type": "Collection",
          "name": "Notes Folder"
        }
      }
    end
  
end
