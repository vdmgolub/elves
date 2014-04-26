require_relative '../spec_helper'
require_relative '../../lib/jobs/rss_retriever_job'

describe RssRetrieverJob do
  describe ".perform" do
    before do
      fixture_path = File.expand_path File.join(File.dirname(__FILE__), "..", "fixtures", "example.rss")

      @url = "file://#{URI.escape(fixture_path)}"
      @config = { "feed1" => { "url" => @url, "keywords" => ["1 item"] },
                  "feed2" => { "url" => @url, "keywords" => ["2 item"] } }

      @download_list = { "feed1" => [{ title: "Item 1", url: "https://example.com/download?item=1" }],
                         "feed2" => [{ title: "Item 2", url: "https://example.com/download?item=2" }] }

      Feeds.expects(:config).returns(@config)
    end

    it "adds a download job with links list" do
      Resque.expects(:enqueue).with(DownloadJob, @download_list)

      RssRetrieverJob.perform
    end
  end
end
