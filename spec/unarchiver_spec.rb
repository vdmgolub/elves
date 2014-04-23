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
  before do
    FakeFS.activate!
  end

  after do
    FakeFS.deactivate!
  end

  describe ".search" do
    before do
      @path = File.expand_path('/tmp')
      FileUtils.mkdir_p(@path)

      @archives = ["#{@path}/archive1.rar", "#{@path}/archive2.rar"]
      @archives.each { |a| FileUtils.touch(a) }
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

  describe ".extract" do
    before do
      @archive_path = "path/to/archive.rar"
      @destination_path = "/tmp"
      FileUtils.mkdir_p(@destination_path)

      @archived_files = ["file1.txt", "file2.txt"]
      @extracted_files = @archived_files.map { |f| "#{@destination_path}/#{f}" }
    end

    it "extracts files to given path" do
      Unrar.any_instance.expects(:extract).with(@destination_path).once.returns(@extracted_files)
      Unarchiver.extract(@archive_path, @destination_path)
    end

    it "returns full paths of extracted files" do
      Unrar.any_instance.expects(:extract).with(@destination_path).once.returns(@extracted_files)
      Unarchiver.extract(@archive_path, @destination_path).must_equal @extracted_files
    end
  end

  describe ".extract_from_path" do
    before do
      @archive_path = "path/to/archives"
      FileUtils.mkdir_p(@archive_path)

      @destination_path = "/tmp"
      FileUtils.mkdir_p(@destination_path)

      @archives = { "archive1.rar" => ["#{@destination_path}/file1.txt", "#{@destination_path}/file2.txt"],
                    "archive2.rar" => ["#{@destination_path}/file3.txt", "#{@destination_path}/file4.txt"] }

      @archives.keys.each { |a| FileUtils.touch("#{@archive_path}/#{a}") }


      @extracted_files = @archives.values.flatten
    end

    it "extracts all found archives" do
      @archives.each do |archive, files|
        Unrar.any_instance.expects(:extract).with(@destination_path).once.returns()
      end

      Unarchiver.extract_from_path(@archive_path, @destination_path)
    end

    it "returns list of extracted files" do
      @archives.each do |archive, files|
        Unrar.any_instance.expects(:extract).with(@destination_path).once.returns(files)
      end

      Unarchiver.extract_from_path(@archive_path, @destination_path).each do |f|
        @extracted_files.must_include f
      end
    end
  end
end
