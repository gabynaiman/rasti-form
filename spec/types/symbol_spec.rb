require 'minitest_helper'

describe Rasti::Form::Types::Symbol do
  
  ['text', :symbol, true, false, 100, Time.now, [1,2], {a: 1, b: 2}, Object.new].each do |value|
    it "#{value.inspect} -> \"#{value.to_s.to_sym}\"" do
      Rasti::Form::Types::Symbol.cast(value).must_equal value.to_s.to_sym
    end
  end

  it 'nil -> CastError' do
    error = proc { Rasti::Form::Types::Symbol.cast(nil) }.must_raise Rasti::Form::CastError
    error.message.must_equal 'Invalid cast: nil -> Rasti::Form::Types::Symbol'
  end

end