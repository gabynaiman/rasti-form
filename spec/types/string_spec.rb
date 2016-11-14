require 'minitest_helper'

describe Rasti::Form::Types::String do
  
  ['text', :symbol, true, false, 100, Time.now, [1,2], {a: 1, b: 2}, Object.new].each do |value|
    it "#{value.inspect} -> \"#{value.to_s}\"" do
      Rasti::Form::Types::String.cast(value).must_equal value.to_s
    end
  end

  it 'nil -> CastError' do
    error = proc { Rasti::Form::Types::String.cast(nil) }.must_raise Rasti::Form::CastError
    error.message.must_equal 'Invalid cast: nil -> Rasti::Form::Types::String'
  end

end