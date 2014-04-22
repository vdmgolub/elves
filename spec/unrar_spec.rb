require_relative './spec_helper'
require_relative '../lib/unrar'

describe Unrar do
  describe ".list" do
    context "when file is a correct RAR archive" do
      before do
        @filenames = "file1\nfile2\n"
        Unrar.expects(:`).once.returns(@filenames)
      end

      it "returns names of archived files" do
        Unrar.list("correct/path/to/archive.rar").must_equal @filenames.split("\n")
      end
    end

    context "when file is not a RAR archive or doesn't exist" do
      before do
        Unrar.expects(:`).once.returns("")
      end

      it "returns an empty list" do
        Unrar.list("archive.txt").must_equal []
      end
    end

    context "when unrar application is not found" do
      before do
        Unrar.expects(:`).once.raises(Errno::ENOENT)
      end

      it "returns and empty list" do
        Unrar.list("path/to/archive").must_equal []
      end
    end
  end
end
