require_relative '../spec_helper'
require_relative '../../lib/jobs/download_job'

describe DownloadJob do
  describe ".perform" do
    before do
      @config = { "feed1" => { "prefix" => "[f1]", "ext" => "txt", "destination" => "/tmp" },
                  "feed2" => { "prefix" => "[f2]", "ext" => "md", "destination" => "/tmp" } }

      Feeds.expects(:config).returns(@config)

      @urls_list = { "feed1" => [{ title: "item1", url: "url" },
                                 { title: "item2", url: "url" }],
                     "feed2" => [{ title: "item3", url: "url" }] }

      @downloading_times = @urls_list.values.flatten.length
    end

    it "downloads files from a given list" do
      Downloader.any_instance.expects(:run).times(@downloading_times)

      DownloadJob.perform(@urls_list)
    end

    context "when there is no config section for resource" do
      it "skips downloading of its urls" do
        list = @urls_list.merge({ "feed3" => [{ title: "item4", url: "url" }] })

        Downloader.any_instance.expects(:run).times(@downloading_times)

        DownloadJob.perform(list)
      end
    end
  end
end
