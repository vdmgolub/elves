require_relative './spec_helper'
require_relative '../lib/unrar'

def stub_system_call(output)
  Unrar.any_instance.expects(:`).once.returns(output)
end

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
    end

    context "when file is a correct RAR archive" do
      before do
        @filenames = "file1\nfile2\n"
        stub_system_call(@filenames)
      end

      it "returns names of archived files" do
        @archive.filenames.must_equal @filenames.split("\n")
      end
    end

    context "when file is not a RAR archive or doesn't exist" do
      before do
        stub_system_call("")
      end

      it "returns an empty list" do
        @archive.filenames.must_equal []
      end
    end

    context "when unrar application is not found" do
      before do
        Unrar.any_instance.expects(:`).once.raises(Errno::ENOENT)
      end

      it "returns and empty list" do
        @archive.filenames.must_equal []
      end
    end
  end
end
