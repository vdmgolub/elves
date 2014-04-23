require_relative './spec_helper'
require_relative '../lib/unarchiver'
require 'fakefs/safe'

module MiniTest
  module Assertions
    alias :actual_diff :diff

    def diff exp, act
      FakeFS.without do
        actual_diff exp, act
      end
    end
  end
end

describe Unarchiver do
  describe ".search" do
    before do
      FakeFS.activate!
      @path = File.expand_path('/tmp')
      FileUtils.mkdir_p(@path)

      @archives = ["#{@path}/archive1.rar", "#{@path}/archive2.rar"]
      @archives.each { |a| FileUtils.touch(a) }
    end

    after do
      FakeFS.deactivate!
    end

    context "when directory has archives" do
      context "and path doesn't have trailing slash" do
        it "returns list of file paths" do
          Unarchiver.search(@path).must_equal @archives
        end
      end

      context "and path has trailing slash" do
        it "returns list of file paths" do
          Unarchiver.search("#{@path}/").must_equal @archives
        end
      end
    end

    context "when directory doesn't have archives" do
      it "returns empty list" do
        another_path = "#{@path}/no_archives"
        FileUtils.mkdir_p(another_path)
        FileUtils.touch("#{another_path}/not_archive.txt")

        Unarchiver.search(another_path).must_equal []
      end
    end

    context "when directory doesn't exist" do
      it "returns empty list" do
        Unarchiver.search("#{@path}/not_existing_dir").must_equal []
      end
    end
  end
end
