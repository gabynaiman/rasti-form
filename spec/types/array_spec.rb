require 'minitest_helper'

describe Rasti::Form::Types::Array do

  array = [1, '2', Time.now]
  
  it "#{array.inspect} -> #{array.map(&:to_i)}" do
    Rasti::Form::Types::Array[Rasti::Form::Types::Integer].cast(array).must_equal array.map(&:to_i)
  end

  it "#{array.inspect} -> #{array.map(&:to_s)}" do
    Rasti::Form::Types::Array[Rasti::Form::Types::String].cast(array).must_equal array.map(&:to_s)
  end

  [[nil], nil, 1, 'text', :symbol, {a: 1, b: 2}, Object.new].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::Array[Rasti::Form::Types::String].cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::Array[Rasti::Form::Types::String]"
    end
  end

end