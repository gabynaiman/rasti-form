require 'minitest_helper'

describe Rasti::Form::Types::Float do
  
  [100, '200', Time.now,2.0,"12.5"].each do |value|
    it "#{value.inspect} -> #{value.to_i}" do
      Rasti::Form::Types::Float.cast(value).must_equal value.to_f
    end
  end

  [nil, 'text', :symbol, '999'.to_sym, [1,2], {a: 1, b: 2}, Object.new, "1.", ".2","."].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::Float.cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::Float"
    end
  end

end