require 'rails_helper'

RSpec.describe "ActivitySchema" do
  context "valid cases" do
    context "with actor hash" do
      let(:valid_activity) do
        # Example 15: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-create
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "summary": "Sally created a note",
          "type": "Create",
          "actor": {
            "type": "Person",
            "name": "ryan",
          },
          "object": {
            "type": "Message",
            "content": "This is a simple message",
          },
          "published": Time.current.to_s,
          "to": "https://www.w3.org/ns/activitystreams#Public",
        }
      end

      it "validates successfully" do
        result = ActivitySchema.(valid_activity)
        expect(result).to be_success
      end
    end

    context "with actor name" do
      let(:valid_activity) do
        # Example 15: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-create
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "summary": "Sally created a note",
          "type": "Create",
          "actor": "ryan",
          "object": {
            "type": "Message",
            "content": "This is a simple message",
          },
          "published": Time.current.to_s,
          "to": "https://www.w3.org/ns/activitystreams#Public",
        }
      end

      it "validates successfully" do
        result = ActivitySchema.(valid_activity)
        expect(result).to be_success
      end
    end
  end

  context "invalid cases" do
    context "@context" do
      context "when @context is missing" do
        let(:invalid_activity) do
          {
            "summary": "Sally created a note",
            "type": "Create",
            "actor": {
              "type": "Person",
              "name": "ryan",
            },
            "object": {
              "type": "Message",
              "content": "This is a simple message",
            },
            "published": Time.current.to_s,
            "to": "https://www.w3.org/ns/activitystreams#Public",
          }
        end

        it "is invalid" do
          result = ActivitySchema.(invalid_activity)
          expect(result).to be_failure
          expect(result.errors[:@context]).to eq(["is missing"])
        end
      end

      context "when @context is wrong" do
        let(:invalid_activity) do
          {
            "@context": "Not the proper context",
            "summary": "Sally created a note",
            "type": "Create",
            "actor": {
              "type": "Person",
              "name": "ryan",
            },
            "object": {
              "type": "Message",
              "content": "This is a simple message",
            },
            "published": Time.current.to_s,
            "to": "https://www.w3.org/ns/activitystreams#Public",
          }
        end

        it "is invalid" do
          result = ActivitySchema.(invalid_activity)
          expect(result).to be_failure
          expect(result.errors[:@context]).to eq(["must be equal to https://www.w3.org/ns/activitystreams"])
        end
      end
    end

    context "actor" do
      context "missing" do
        let(:invalid_activity) do
          {
            "@context": "https://www.w3.org/ns/activitystreams",
            "summary": "Sally created a note",
            "type": "Create",
            "object": {
              "type": "Message",
              "content": "This is a simple message",
            },
            "published": Time.current.to_s,
            "to": "https://www.w3.org/ns/activitystreams#Public",
          }
        end

        it "is invalid" do
          result = ActivitySchema.(invalid_activity)
          expect(result.errors[:actor]).to eq(["is missing"])
        end
      end

      context "wrong type" do
        let(:invalid_activity) do
          {
            "@context": "https://www.w3.org/ns/activitystreams",
            "summary": "Sally created a note",
            "type": "Create",
            "actor": {
              "type": "MovieStar",
              "name": "Ryan Reynolds",
            },
            "object": {
              "type": "Message",
              "content": "This is a simple message",
            },
            "published": Time.current.to_s,
            "to": "https://www.w3.org/ns/activitystreams#Public",
          }
        end

        it "is invalid" do
          result = ActivitySchema.(invalid_activity)
          expect(result.errors[:actor][:type]).to eq(["must be one of: Application, Group, Organization, Person, Service"])
        end
      end
    end
  end
end
