require 'spec_helper'
require_relative '../../lib/tagging_sync_verifier'

RSpec.describe TaggingSyncVerifier do
  describe '#messages' do
    it "reports success when the taggings are the same" do
      stub_content_api(
        "A-CID" => {
          "mainstream_browse_pages" => ["XX"],
          "topics":["XX"],
          "organisations":["XX","XX"],
          "parent":["XX"]
        }
      )

      stub_content_store(
        "A-CID" => {
          "mainstream_browse_pages" => ["XX"],
          "topics":["XX"],
          "organisations":["XX","XX"],
          "parent":["XX"]
        }
      )

      verifier = TaggingSyncVerifier.new("travel-advice-publisher")
      verifier.verify_taggings_are_in_sync

      expect(verifier.output).to eql(["Checking travel-advice-publisher", "Taggings are in sync!"])
      expect(verifier.error).to be false
    end

    it "reports any diffs when not in sync" do
      stub_content_api(
        "A-CID" => {
          "mainstream_browse_pages":["XX"],
          "organisations":["XX","XX"],
        }
      )

      stub_content_store(
        "A-CID" => {
          "mainstream_browse_pages":["XX"],
          "organisations":["SOMETHING-ELSE","XX"],
        }
      )

      verifier = TaggingSyncVerifier.new("travel-advice-publisher")
      verifier.verify_taggings_are_in_sync

      expect(verifier.output).to eql(
        [
          "Checking travel-advice-publisher",
          "Taggings are not in sync!",
          "A-CID has the following tags in content-api:", { "mainstream_browse_pages" => ["XX"], "organisations"=>["XX", "XX"]},
          "A-CID has the following tags in content-store:", { "mainstream_browse_pages" => ["XX"], "organisations"=>["SOMETHING-ELSE", "XX"] }
        ]
      )
      expect(verifier.error).to be true
    end

    it "doesn't report diffs for pages that are not in the content-store" do
      stub_content_api(
        "A-CID" => {
          "mainstream_browse_pages" => ["XX"],
          "organisations" => ["XX","XX"],
        }
      )

      stub_content_store(
        "A-CID" => {
          "mainstream_browse_pages" => ["XX"],
          "organisations" => ["XX","XX"],
        },
        "EXISTS-ONLY-IN-CONTENT-STORE" => {
          "mainstream_browse_pages" => ["XX"],
          "organisations" => ["SOMETHING-ELSE","XX"],
        }
      )

      verifier = TaggingSyncVerifier.new("travel-advice-publisher")
      verifier.verify_taggings_are_in_sync

      expect(verifier.output).to eql(["Checking travel-advice-publisher", "Taggings are in sync!"])
      expect(verifier.error).to be false
    end
  end

  def stub_content_api(payload)
    stub_request(:get, "http://contentapi.dev.gov.uk/debug/taggings-per-app.json?app=travel-advice-publisher").
      to_return(body: payload.to_json )
  end

  def stub_content_store(payload)
    stub_request(:get, "http://content-store.dev.gov.uk/debug/taggings-per-app.json?app=travel-advice-publisher").
      to_return(body: payload.to_json)
  end
end
