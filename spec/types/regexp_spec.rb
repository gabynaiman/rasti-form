require 'minitest_helper'

describe Rasti::Form::Types::Regexp do

  ['[a-z]', /[a-z]/].each do |value|
    it "#{value.inspect} -> #{Regexp.new(value).inspect}" do
      Rasti::Form::Types::Regexp.cast(value).must_equal Regexp.new(value)
    end
  end

  [nil, '[a-z', :symbol, [1,2], {a: 1, b: 2}, Object.new, 5].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::Regexp.cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::Regexp"
    end
  end

end