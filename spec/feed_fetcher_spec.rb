require_relative './spec_helper'
require_relative '../lib/feed_fetcher'

describe FeedFetcher do
  before do
    path = File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "fixtures", "example.rss")
    @url = "file://#{URI.escape(path)}"

    @fetcher = FeedFetcher.new(@url)
  end

  describe "#source" do
    it "returns feed's URL" do
      @fetcher.source.must_equal @url
    end
  end

  describe "#fetch" do
    it "returns entries list" do
      @fetcher.fetch.length.must_equal 2
    end

    context "when URL is incorrect" do
      it "returns empty list" do
        fetcher = FeedFetcher.new("file://incorrect/path/to/feed")
        fetcher.fetch.must_equal []
      end
    end
  end
end
