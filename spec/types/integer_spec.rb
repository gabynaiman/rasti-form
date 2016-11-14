require 'minitest_helper'

describe Rasti::Form::Types::Integer do
  
  [100, '200', Time.now, 2.1, "12.5"].each do |value|
    it "#{value.inspect} -> #{value.to_i}" do
      Rasti::Form::Types::Integer.cast(value).must_equal value.to_i
    end
  end

  [nil, 'text', :symbol, '999'.to_sym, [1,2], {a: 1, b: 2}, Object.new].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::Integer.cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::Integer"
    end
  end

end