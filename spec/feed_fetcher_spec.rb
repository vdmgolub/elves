require_relative './spec_helper'
require_relative '../lib/feed_fetcher'

describe FeedFetcher do
  before do
    @url = "http://example.com/rss"
    @fetcher = FeedFetcher.new(@url)
  end

  describe "#source" do
    it "returns feed's URL" do
      @fetcher.source.must_equal @url
    end
  end

  describe "#fetch" do
    it "calls Feedjira for help" do
      Feedjira::Feed.expects(:fetch_and_parse).with(@fetcher.source)

      @fetcher.fetch
    end
  end
end
