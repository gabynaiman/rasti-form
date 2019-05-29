require 'minitest_helper'

describe Rasti::Form::Types::String, 'Formatted' do

  email_regexp = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  ['user@mail.com'.to_sym, 'user.name-123@mail-test.com.ar'].each do |value|
    it "#{value.inspect} -> #{value.to_s}" do
      Rasti::Form::Types::String[email_regexp].cast(value).must_equal value
    end
  end

  [nil, 'text', :symbol, '999'.to_sym, [1,2], {a: 1, b: 2}, Object.new, 5].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::String[email_regexp].cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::String[#{as_string(email_regexp)}]"
    end
  end

end