require 'minitest_helper'

describe Rasti::Form::Types::Boolean do
  
  [true, 'true', 'True', 'TRUE', 'T'].each do |value|
    it "#{value.inspect} -> true" do
      Rasti::Form::Types::Boolean.cast(value).must_equal true
    end
  end

  [false, 'false', 'False', 'FALSE', 'F'].each do |value|
    it "#{value.inspect} -> false" do
      Rasti::Form::Types::Boolean.cast(value).must_equal false
    end
  end

  [nil, 'text', 123, :false, :true, Time.now, [1,2], {a: 1, b: 2}, Object.new].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::Boolean.cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::Boolean"
    end
  end

end