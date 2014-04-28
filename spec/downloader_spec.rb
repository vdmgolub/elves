require_relative './spec_helper'
require_relative './fakefs_helper'
require_relative '../lib/downloader'
require 'fakeweb'

describe Downloader do
  describe "#prefix" do
    it "returns prefix value" do
      [:prefix, "prefix"].each do |key|
        config = { key => "f1" }
        downloader = Downloader.new(config)
        downloader.prefix.must_equal "[#{config[key]}]"
      end
    end
  end

  describe "#ext" do
    it "returns extension value" do
      [:ext, "ext"].each do |key|
        config = { key => "txt" }
        downloader = Downloader.new(config)
        downloader.ext.must_equal config[key]
      end
    end
  end

  describe "#destination" do
    it "returns destination path value" do
      [:destination, "destination"].each do |key|
        config = { key => "~/path/to/download" }
        downloader = Downloader.new(config)
        downloader.destination.must_equal File.expand_path(config[key])
      end
    end
  end

  describe "#run" do
    before do
      FakeFS.activate!

      config = { prefix: "f1", ext: "md", destination: "/tmp/destination" }
      @downloader = Downloader.new(config)

      @title = "Item 1"
      @url = "http://example.com/item1.txt"

      @filename = "[f1].item.1.md"

      FakeWeb.register_uri(:get, @url, body: "Hello world!")
      FakeWeb.register_uri(:head, @url, body: "")
    end

    after do
      FileUtils.rm_r(@downloader.destination) if File.directory?(@downloader.destination)
      FakeFS.deactivate!
    end

    context "when destination directory doesn't exist" do
      it "creates it" do
        @downloader.run(@title, @url)

        File.directory?(@downloader.destination).must_equal true
      end
    end

    context "when extension is set" do
      before do
        @base_name = "#{@title.downcase.gsub(' ', '.')}.#{@downloader.ext}"
      end

      it "saves downloaded file with custom name" do
        filename = "#{@downloader.prefix}.#{@base_name}"

        @downloader.run(@title, @url)

        File.exists?(File.join(@downloader.destination, filename)).must_equal true
      end

      context "when prefix is not set" do
        before do
          @downloader.prefix = nil
        end

        it "saves downloaded file without prefix" do
          @downloader.run(@title, @url)

          File.exists?(File.join(@downloader.destination, @base_name)).must_equal true
        end
      end
    end

    context "when title is not set" do
      it "saves downloaded file with prefixed original name" do
        name = "#{@downloader.prefix}.#{File.basename(@url)}"
        full_path = File.join(@downloader.destination, name)

        @downloader.run(nil, @url)
        File.exists?(full_path).must_equal true
      end

      context "when prefix is not set" do
        before do
          @downloader.prefix = nil
        end

        it "saves downloaded file with original name" do
          full_path = File.join(@downloader.destination, File.basename(@url))

          @downloader.run(nil, @url)
          File.exists?(full_path).must_equal true
        end
      end
    end

    context "when extension is not set" do
      before do
        @downloader.ext = nil
      end

      it "saves downloaded file with prefixed original name" do
        @downloader.run(@title, @url)

        name = "#{@downloader.prefix}.#{File.basename(@url)}"
        full_path = File.join(@downloader.destination, name)
        File.exists?(full_path).must_equal true
      end
    end

    it "returns name of saved file" do
      @downloader.run(@title, @url).must_equal @filename
    end

    context "when URL is incorrect" do
      before do
        FakeWeb.register_uri(:get, @url, body: "", status: ["404", "Not Found"])
      end

      it "skips downloading" do
        Mechanize::File.any_instance.expects(:save!).never

        @downloader.run(@title, @url)
      end

      it "returns empty string" do
        @downloader.run(@title, @url).must_equal ""
      end
    end

    context "when given URL has no body" do
      before do
        FakeWeb.register_uri(:get, @url, body: "")
      end

      it "returns empty string" do
        @downloader.run(@title, @url).must_equal ""
      end
    end

    context "when file already exists" do
      before do
        FileUtils.mkdir_p(@downloader.destination)
        FileUtils.touch(File.join(@downloader.destination, @filename))
      end

      it "skips downloading" do
        Mechanize::File.any_instance.expects(:save!).never

        @downloader.run(@title, @url)
      end

      it "returns file name" do
        @downloader.run(@title, @url).must_equal @filename
      end
    end
  end
end
