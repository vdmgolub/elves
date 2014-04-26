require_relative './spec_helper'
require_relative '../lib/rss_entries_filter'

describe RssEntriesFilter do
  describe ".execute" do
    before do
      @entries = [{ title: "i.have.cheeseburger", url: "http:/cheese.com" },
                  { title: "all.your.base.are.belong.to.us", url: "http://base.com" },
                  { title: "all.my.cheeseburger.are.belong.to.me", url: "http://nope.com" }]

      @keywords = ["cheeseburger", "base us"]
    end

    it "returns items list sorted by keyword sets" do
      RssEntriesFilter.execute(@entries, @keywords).must_equal @entries[0..-1]
    end

    it "runs matcher for each keyword set" do
      KeywordsMatcher.expects(:match?).times(@entries.length * @keywords.length)

      RssEntriesFilter.execute(@entries, @keywords)
    end
  end

  describe ".prepare_keywords" do
    it "returns list or keywords list" do
      keywords = ["one two three", "one two"]
      result = [["one", "two", "three"], ["one", "two"]]

      RssEntriesFilter.prepare_keywords(keywords).must_equal result
    end

    context "when keywords list is empty" do
      it "returns empty list" do
        RssEntriesFilter.prepare_keywords([]).must_equal []
      end
    end
  end

  describe ".item_match?" do
    before do
      @keywords_list = [["one"], ["two", "three"]]
    end

    context "when phrase matches any keywords set in keywords list" do
      it "returns true" do
        phrase = "two three four"

        RssEntriesFilter.item_match?(phrase, @keywords_list).must_equal true
      end
    end

    context "when phrase doesn't match any keywords set" do
      it "returns false" do
        phrase = "three four"

        RssEntriesFilter.item_match?(phrase, @keywords_list).must_equal false
      end
    end
  end
end
