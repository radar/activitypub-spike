require 'rails_helper'

RSpec.describe "ObjectSchema" do
  context "valid cases" do
    context "basic object" do
      let(:valid_object) do
        # Example 1: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-object
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Object",
          "id": "http://www.test.example/object/1",
          "name": "A Simple, non-specific object"
        }
      end
  
      it "validates successfully" do
        result = ObjectSchema.(valid_object)
        expect(result).to be_success
      end
    end

    context "object with attachment" do
      context "object attachment" do
        let(:valid_object) do
          # Example 66: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-attachment
          {
            "@context": "https://www.w3.org/ns/activitystreams",
            "type": "Note",
            "name": "Have you seen my cat?",
            "attachment": [
              {
                "type": "Image",
                "content": "This is what he looks like.",
                "url": "http://example.org/cat.jpeg"
              }
            ]
          }
        end
  
        it "validates successfully" do
          result = ObjectSchema.(valid_object)
          expect(result).to be_success
        end
      end

      context "multiple attachments" do
        let(:valid_object) do
          # Example 66: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-attachment
          {
            "@context": "https://www.w3.org/ns/activitystreams",
            "type": "Note",
            "name": "Have you seen my cat?",
            "attachment": [
              {
                "type": "Image",
                "content": "This is what he looks like.",
                "url": "http://example.org/cat.jpeg"
              },
              {
                "@context": "https://www.w3.org/ns/activitystreams",
                "type": "Link",
                "href": "http://example.org/abc",
                "hreflang": "en",
                "mediaType": "text/html",
                "name": "An example link"
              }
            ]
          }
        end
  
        it "validates successfully" do
          result = ObjectSchema.(valid_object)
          expect(result).to be_success
        end
      end

      context "link attachment" do
        let(:valid_object) do
          # Example 66: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-attachment
          {
            "@context": "https://www.w3.org/ns/activitystreams",
            "type": "Note",
            "name": "Have you seen my cat?",
            "attachment": [
              {
                "@context": "https://www.w3.org/ns/activitystreams",
                "type": "Link",
                "href": "http://example.org/abc",
                "hreflang": "en",
                "mediaType": "text/html",
                "name": "An example link"
              }
            ]
          }
        end
  
        it "validates successfully" do
          result = ObjectSchema.(valid_object)
          expect(result).to be_success
        end
      end
      
    end

    context "object with attributedTo property" do
      let(:valid_object) do
        # Example 67: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-attributedto
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Image",
          "name": "My cat taking a nap",
          "url": "http://example.org/cat.jpeg",
          "attributedTo": [
            {
              "type": "Person",
              "name": "Sally"
            }
          ]
        }
      end

      it "validates successfully" do
        result = ObjectSchema.(valid_object)
        expect(result).to be_success
      end
    end

    context "object with attributedTo property" do
      let(:valid_object) do
        # Example 67: https://www.w3.org/TR/activitystreams-vocabulary/%23dfn-object#dfn-attributedto
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Image",
          "name": "My cat taking a nap",
          "url": "http://example.org/cat.jpeg",
          "attributedTo": [
            {
              "type": "Person",
              "name": "Sally"
            }
          ]
        }
      end

      let(:valid_object_two) do
        # Example 68: https://www.w3.org/TR/activitystreams-vocabulary/%23dfn-object#dfn-attributedto
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Image",
          "name": "My cat taking a nap",
          "url": "http://example.org/cat.jpeg",
          "attributedTo": [
            "http://joe.example.org",
            {
              "type": "Person",
              "name": "Sally"
            }
          ]
        }
      end
  
      it "validates successfully" do
        result = ObjectSchema.(valid_object)
        expect(result).to be_success
        result = ObjectSchema.(valid_object_two)
        expect(result).to be_success
      end
    end

    context "object with attachment" do
      context "object attachment" do
        let(:valid_object) do
          # Example 66: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-attachment
          {
            "@context": "https://www.w3.org/ns/activitystreams",
            "type": "Note",
            "name": "Have you seen my cat?",
            "attachment": [
              {
                "type": "Image",
                "content": "This is what he looks like.",
                "url": "http://example.org/cat.jpeg"
              }
            ]
          }
        end
  
        it "validates successfully" do
          result = ObjectSchema.(valid_object)
          expect(result).to be_success
        end
      end

      context "multiple attachments" do
        let(:valid_object) do
          # Example 66: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-attachment
          {
            "@context": "https://www.w3.org/ns/activitystreams",
            "type": "Note",
            "name": "Have you seen my cat?",
            "attachment": [
              {
                "type": "Image",
                "content": "This is what he looks like.",
                "url": "http://example.org/cat.jpeg"
              },
              {
                "@context": "https://www.w3.org/ns/activitystreams",
                "type": "Link",
                "href": "http://example.org/abc",
                "hreflang": "en",
                "mediaType": "text/html",
                "name": "An example link"
              }
            ]
          }
        end
  
        it "validates successfully" do
          result = ObjectSchema.(valid_object)
          expect(result).to be_success
        end
      end

      context "with content" do
        let(:valid_object) do
          # Example 114: https://www.w3.org/TR/activitystreams-vocabulary/%23dfn-object#dfn-content
          {
            "@context": "https://www.w3.org/ns/activitystreams",
            "summary": "A simple note",
            "type": "Note",
            "content": "A <em>simple</em> note"
          }
        end

        let(:markdown_content_object) do
          # Example 116: https://www.w3.org/TR/activitystreams-vocabulary/%23dfn-object#dfn-content
          {
            "@context": "https://www.w3.org/ns/activitystreams",
            "summary": "A simple note",
            "type": "Note",
            "mediaType": "text/html",
            "content": "<b>A simple note</b><br>A simple HTML `note`"
          }
        end
  
        it "validates successfully" do
          result = ObjectSchema.(valid_object)
          expect(result).to be_success

          result = ObjectSchema.(markdown_content_object)
          expect(result).to be_success
        end
      end
      
    end

    context "object with startTime and endTime" do
      let(:valid_object) do
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Event",
          "name": "Going-Away Party for Jim",
          "startTime": "2014-12-31T23:00:00-08:00",
          "endTime": "2015-01-01T06:00:00-08:00"
        }
      end

      it "validates successfully" do
        result = ObjectSchema.(valid_object)
        expect(result).to be_success
      end
    end

    context "object with published property" do
      let(:valid_object) do
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "summary": "A simple note",
          "type": "Note",
          "content": "Fish swim.",
          "published": "2014-12-12T12:12:12Z"
        }
      end

      it "validates successfully" do
        result = ObjectSchema.(valid_object)
        expect(result).to be_success
      end
    end

    context "with routing information" do
      let(:valid_object) do
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "summary": "Sally offered the post to John",
          "type": "Offer",
          "actor": "http://sally.example.org",
          "object": "http://example.org/posts/1",
          "target": "http://john.example.org",
          "to": [ "http://joe.example.org" ],
          "cc": [ "http://joe.example.org" ],
          "bcc": [ "http://joe.example.org" ]
        }
      end

      it "validates successfully" do
        result = ObjectSchema.(valid_object)
        expect(result).to be_success
      end
    end
    
  end

  context "invalid cases" do
    context "without @context" do
      let(:invalid_object) do
        {
          "type": "Object",
          "id": "http://www.test.example/object/1",
          "name": "A Simple, non-specific object"
        }
      end

      it "does not validate" do
        result = ObjectSchema.(invalid_object)
        expect(result).to be_failure
      end
    end

    context "object without a type" do
      let(:invalid_object) do
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "id": "http://www.test.example/object/1",
          "name": "A Simple, non-specific object"
        }
      end

      it "does not validate" do
        result = ObjectSchema.(invalid_object)
        expect(result).to be_failure
      end
    end

    context "nested object without type" do
      let(:invalid_object) do
        # Example 66: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-attachment
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Note",
          "name": "Have you seen my cat?",
          "attachment": [
            {
              "content": "This is what he looks like.",
              "url": "http://example.org/cat.jpeg"
            }
          ]
        }
      end

      it "does not validate" do
        result = ObjectSchema.(invalid_object)
        expect(result).to be_failure
      end
    end

    context "nested link without a href" do
      let(:invalid_object) do
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Note",
          "name": "Have you seen my cat?",
          "attachment": [
            {
              "@context": "https://www.w3.org/ns/activitystreams",
              "type": "Link",
              "hreflang": "en",
              "mediaType": "text/html",
              "name": "An example link"
            }
          ]
        }
      end

      it "does not validate" do
        result = ObjectSchema.(invalid_object)
        expect(result).to be_failure
      end
    end
  end
end