require 'minitest_helper'

describe Rasti::Form::Types::Hash do

  it "{'a' => '123'} -> {a: 123}" do
    Rasti::Form::Types::Hash[Rasti::Form::Types::Symbol, Rasti::Form::Types::Integer].cast('a' => '123').must_equal a: 123
  end

  it "{'1' => :abc} -> {1 => 'abc'}" do
    Rasti::Form::Types::Hash[Rasti::Form::Types::Integer, Rasti::Form::Types::String].cast('1' => :abc).must_equal 1 => 'abc'
  end

  [nil, 1, 'text', :symbol, {a: true}, Object.new].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::Hash[Rasti::Form::Types::Symbol, Rasti::Form::Types::Integer].cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::Hash[Rasti::Form::Types::Symbol, Rasti::Form::Types::Integer]"
    end
  end

end