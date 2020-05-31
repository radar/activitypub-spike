require 'rails_helper'

RSpec.describe "LinkSchema" do
  context "valid cases" do
    let(:valid_link) do
      # Example 2: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-link
      {
        "@context": "https://www.w3.org/ns/activitystreams",
        "type": "Link",
        "href": "http://example.org/abc",
        "hreflang": "en",
        "mediaType": "text/html",
        "name": "An example link"
      }
    end

    it "validates successfully" do
      result = LinkSchema.(valid_link)
      expect(result).to be_success
    end
  end

  context "invalid cases" do
    context "missing href" do
      let(:invalid_link) do
        # Example 2: https://www.w3.org/TR/activitystreams-vocabulary/#dfn-link
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Link",
          "hreflang": "en",
          "mediaType": "text/html",
          "name": "An example link"
        }
      end

      it "does not validate" do
        result = LinkSchema.(invalid_link)
        expect(result).to be_failure
      end
    end

    context "invalid height" do
      let(:invalid_link) do
        # Example 120 https://www.w3.org/TR/activitystreams-vocabulary/#dfn-height
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Link",
          "href": "http://example.org/image.png",
          "height": 0,
          "width": 100
        }
      end

      it "does not validate" do
        result = LinkSchema.(invalid_link)
        expect(result).to be_failure
      end
    end

    context "invalid width" do
      let(:invalid_link) do
        # Example 120 https://www.w3.org/TR/activitystreams-vocabulary/#dfn-height
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Link",
          "href": "http://example.org/image.png",
          "height": 10,
          "width": -10
        }
      end

      it "does not validate" do
        result = LinkSchema.(invalid_link)
        expect(result).to be_failure
      end
    end

    context "invalid MIME type" do
      let(:invalid_link) do
        # https://www.w3.org/TR/activitystreams-vocabulary/#dfn-mediatype
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Link",
          "href": "http://example.org/abc",
          "hreflang": "en",
          "mediaType": "not/valid",
          "name": "Next"
        }
      end

      it "does not validate" do
        result = LinkSchema.(invalid_link)
        expect(result).to be_failure
      end
    end
  end
end