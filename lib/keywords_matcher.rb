class KeywordsMatcher
  def self.match?(phrase, keywords)
    regex = build_regex(keywords)
    !!regex.match(phrase)
  end

  private

  def self.build_regex(keywords)
    assertions = keywords.map{ |k| "(?=.*#{k})" }.join

    /^#{assertions}/i
  end
end
