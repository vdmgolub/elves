require_relative './keywords_matcher'

class RssEntriesFilter
  def self.execute(entries, keywords)
    keywords_list = prepare_keywords(keywords)

    items = entries.map do |entry|
      title = entry[:title]

      { title: title, url: entry[:url] } if item_match?(title, keywords_list)
    end

    items.compact
  end

  def self.prepare_keywords(keywords_list)
    keywords_list.map { |k| k.split(' ') }
  end

  def self.item_match?(title, keywords_list)
    keywords_list.each do |keywords|
      return true if KeywordsMatcher.match?(title, keywords)
    end

    false
  end
end
