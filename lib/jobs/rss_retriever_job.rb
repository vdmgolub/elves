require 'resque'
require_relative '../../initializers/feeds'
require_relative './download_job'
require_relative '../feed_fetcher'
require_relative '../rss_entries_filter'

class RssRetrieverJob
  def self.perform
    list = {}

    Feeds.config.each do |name, resource|
      fetcher = FeedFetcher.new(resource['url'])

      items = RssEntriesFilter.execute(fetcher.fetch, resource['keywords'])

      list[name] = items if items.length > 0
    end

    Resque.enqueue(DownloadJob, list)
  end
end
