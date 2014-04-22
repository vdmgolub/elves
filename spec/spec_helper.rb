require 'minitest/autorun'
require 'mocha/mini_test'

module MiniTest
  class Spec
    class << self
      alias_method :context, :describe
    end
  end
end
