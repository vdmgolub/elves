require 'feedjira'

class FeedFetcher
  attr_reader :source

  def initialize(url)
    @source = url
  end

  def fetch
    Feedjira::Feed.fetch_and_parse(source)
  end
end
