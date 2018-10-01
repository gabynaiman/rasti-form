require 'minitest_helper'

describe Rasti::Form::Types::IO do
  
  [StringIO.new, File.new(__FILE__)].each do |value|
    it "#{value.inspect} -> #{value}" do
      Rasti::Form::Types::IO.cast(value).must_equal value
    end
  end

  [nil, 'text', 123, :symbol, [1,2], {a: 1, b: 2}, Object.new].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::IO.cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::IO"
    end
  end

end