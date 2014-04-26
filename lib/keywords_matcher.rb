class KeywordsMatcher
  def self.match?(phrase, keywords)
    if keywords && keywords.length > 0
      regex = build_regex(keywords)
      return !!regex.match(phrase)
    end

    true
  end

  private

  def self.build_regex(keywords)
    assertions = keywords.map{ |k| "(?=.*#{k})" }.join

    /^#{assertions}/i
  end
end
