require_relative './spec_helper'
require_relative '../lib/unrar'

describe Unrar do
  before do
    @path = "path/to/archive.rar"
    @archive = Unrar.new(@path)
  end

  describe ".new" do
    it "sets path to archive" do
      @archive.path.must_equal @path
    end
  end

  describe "#filenames" do
    before do
      @command = "unrar lb #{@archive.path}"
    end

    context "when file is a correct RAR archive" do
      before do
        @filenames = "file1\nfile2\n"
        Unrar.any_instance.expects(:`).with(@command).once.returns(@filenames)
      end

      it "returns names of archived files" do
        @archive.filenames.must_equal @filenames.split("\n")
      end
    end

    context "when file is not a RAR archive or doesn't exist" do
      before do
        Unrar.any_instance.expects(:`).with(@command).once.returns("")
      end

      it "returns an empty list" do
        @archive.filenames.must_equal []
      end
    end

    context "when unrar application is not found" do
      before do
        Unrar.any_instance.expects(:`).with(@command).once.raises(Errno::ENOENT)
      end

      it "returns and empty list" do
        @archive.filenames.must_equal []
      end
    end
  end

  describe "#valid?" do
    before do
      @command = "unrar t #{@archive.path}"
    end

    context "when archive is valid" do
      before do
        Unrar.any_instance.expects(:system).with(@command).returns(true)
      end

      it "returns true" do
        @archive.valid?.must_equal true
      end
    end

    context "when archive is not valid" do
      before do
        Unrar.any_instance.expects(:system).with(@command).returns(false)
      end

      it "returns false" do
        @archive.valid?.must_equal false
      end
    end

    context "when unrar application is not found" do
      before do
        Unrar.any_instance.expects(:system).with(@command).returns(nil)
      end

      it "returns false" do
        @archive.valid?.must_equal false
      end
    end
  end

  describe "#extract" do
    before do
      @destination_path = "path/to/extract/"
      @command = "unrar e #{@archive.path} #{@destination_path}"
    end

    context "when archive is valid" do
      before do
        @archive.expects(:valid?).once.returns(true)
        @filenames = ["test1.txt", "test2.txt"]
        @archive.expects(:filenames).once.returns(@filenames)
        @archive.expects(:`).with(@command).once.returns("All OK")
      end

      it "returns full paths for extracted files" do
        result = @filenames.map { |f| "#{@destination_path}#{f}" }
        @archive.extract(@destination_path).must_equal result
      end
    end

    context "when archive is not valid" do
      before do
        @archive.expects(:valid?).once.returns(false)
      end

      it "doesn't call unrar command" do
        @archive.expects(:`).with(@command).never
        @archive.extract(@destination_path)
      end

      it "returns empty list" do
        @archive.extract(@destination_path).must_equal []
      end
    end
  end
end
