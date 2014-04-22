require_relative './spec_helper'
require_relative '../lib/unrar'

describe Unrar do
  describe ".new" do
    it "sets path to archive" do
      path = "path/to/archive.rar"
      archive = Unrar.new(path)

      archive.path.must_equal path
    end
  end

  describe "#filenames" do
    before do
      @archive = Unrar.new("path/to/archive.rar")
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
      @archive = Unrar.new("path/to/archive.rar")
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
end
