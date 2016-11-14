require 'minitest_helper'

describe Rasti::Form::Types::Time do

  time = Time.new 2016, 8, 18
  
  it "#{time.inspect} -> #{time.inspect}" do
    Rasti::Form::Types::Time['%F %T %z'].cast(time).must_equal time
  end

  ['%d/%m/%y', '%Y-%m-%d'].each do |format|
    time_string = time.strftime(format)
    it "#{time_string.inspect} -> #{time.inspect}" do
      Rasti::Form::Types::Time[format].cast(time_string).must_equal time
    end
  end

  [time.strftime('%d/%m/%y'), 'text', nil, 1, :symbol, [1,2], {a: 1, b: 2}, Object.new].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::Time['%F'].cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::Time['%F']"
    end
  end

end