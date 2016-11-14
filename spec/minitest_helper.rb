require 'coverage_helper'
require 'minitest/autorun'
require 'minitest/colorin'
require 'pry-nav'
require 'rasti-form'

module Minitest
  class Test
    def as_string(value)
      value.is_a?(::String) ? "'#{value}'" : value.inspect
    end
  end
end