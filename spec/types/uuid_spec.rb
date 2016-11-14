require 'minitest_helper'

describe Rasti::Form::Types::UUID do

  ['f09b7716-81a9-11e6-a549-bb8f165bcf02', '12345678-1234-1234-1234-123456789123'].each do |value|
    it "#{value.inspect} -> #{value.to_s}" do
      Rasti::Form::Types::UUID.cast(value).must_equal value.to_s
    end
  end

  [nil, 'text', :symbol, '999'.to_sym, [1,2], {a: 1, b: 2}, Object.new, 5, 'f09b7716-81a9-11e6-a549-bb16502', 'f09b7716-11e6-a549-bb8f16502', '-84a9-11e6-a549-bb8f16502', 'f09b7716-81a9-11e6-a549-bh16502'].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::UUID.cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::UUID"
    end
  end

end