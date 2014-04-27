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

module Kernel
  private

  alias :original_open :open

  def open(name, *rest, &block)
    if FakeFS.activated?
      FakeFS::File.open(name, *rest, &block)
    else
      original_open(name, *rest, &block)
    end
  end

  module_function :open
end

# Monkey patched while not merged https://github.com/defunkt/fakefs/pull/234
module FakeFS
  module FileSystem
    private

    def find_recurser(dir, parts)
      return [] unless dir.respond_to? :[]

      pattern , *parts = parts
      matches = case pattern
      when '**'
        case parts
        when ['*']
          parts = [] # end recursion
          directories_under(dir).map do |d|
            d.entries.select{|f| f.is_a?(FakeFile) || f.is_a?(FakeDir) }
          end.flatten.uniq
        when []
          parts = [] # end recursion
          dir.entries.flatten.uniq
        else
          directories_under(dir)
        end
      else
        dir.matches /\A#{pattern.gsub('.', '\.').gsub('?','.').gsub('*', '.*').gsub('[', '\[').gsub(']', '\]').gsub('(', '\(').gsub(')', '\)').gsub(/\{(.*?)\}/) { "(#{$1.gsub(',', '|')})" }}\Z/
      end

      if parts.empty? # we're done recursing
        matches
      else
        matches.map{|entry| find_recurser(entry, parts) }
      end
    end
  end
end
