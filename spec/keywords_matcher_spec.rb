require_relative './spec_helper'
require_relative '../lib/keywords_matcher'

describe KeywordsMatcher do
  describe ".match?" do
    context "when keywords are present" do
      before do
        @keywords = ["kenobi", "hope"]
        @phrases = [
          "help me obi-wan kenobi. you’re my only hope.",
          "help.me.obi-wan.kenobi.you’re.my.only.hope.",
          "help me obi-wan kenobis. i'm hopeless."
        ]
      end

      context "in right order " do
        it "returns true" do
          @phrases.each do |p|
            KeywordsMatcher.match?(p, @keywords).must_equal true
          end
        end
      end

      context "in random order" do
        it "returns true" do
          @phrases.each do |p|
            KeywordsMatcher.match?(p, @keywords.reverse).must_equal true
          end
        end
      end

      context "but keywords and phrase are in different case" do
        before do
          @keywords = ["Kenobi", "Hope"]
          @phrases = [
            "Help me Obi-Wan Kenobi. You’re my only hope.",
            "HELP ME OBI-WAN KENOBI. YOU'RE MY ONLY HOPE",
            "Help me Obi-Wan KeNoBi. I'm hoPeLeSs."
          ]
        end

        it "ignores the case and returns true" do
          @phrases.each do |p|
            KeywordsMatcher.match?(p, @keywords).must_equal true
          end
        end
      end
    end


    context "when any of keywords is missing" do
      before do
        @keywords = ["kenobi", "hope"]
        @phrases = [
          "help me obi-wan. you’re my only hope.",
          "help.me.obi-wan.kenobi.you’re.my.last.resort.",
          "help me obi-wan."
        ]
      end

      it "returns false" do
        @phrases.each do |p|
          KeywordsMatcher.match?(p, @keywords).must_equal false
        end
      end
    end

    context "when keywords list is empty" do
      it "returns true" do
        keywords = []

        KeywordsMatcher.match?("one two three", keywords).must_equal true
      end
    end

    context "when keywords are nil" do
      it "returns true" do
        KeywordsMatcher.match?("one two three", nil).must_equal true
      end
    end
  end
end
