require 'feedjira'

class FeedFetcher
  attr_reader :source

  def initialize(url)
    @source = url
  end

  def fetch
    feed = Feedjira::Feed.fetch_and_parse(source)

    feed.respond_to?(:entries) ? feed.entries : []
  end
end
