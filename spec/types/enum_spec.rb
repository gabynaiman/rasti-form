require 'minitest_helper'

describe Rasti::Form::Types::Enum do

  enum = Rasti::Form::Types::Enum[:a,:b,:c]

  [:a, 'b', "c"].each do |value|
    it "#{value.inspect} -> #{enum}" do
      Rasti::Form::Types::Enum[:a,:b,:c].cast(value).must_equal value.to_s
    end
  end

  [nil, 'text', :symbol, '999'.to_sym, [1,2], {a: 1, b: 2}, Object.new].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::Enum[:a,:b,:c].cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::Enum[\"a\", \"b\", \"c\"]"
    end
  end

end