require_relative '../../initializers/feeds'

class DownloadJob
  def self.perform(list)
    config = Feeds.config

    list.each do |feed_name, urls|
      if config[feed_name]
        downloader = Downloader.new(config[feed_name])

        urls.each { |url| downloader.run(url[:title], url[:url]) }
      end
    end
  end
end
