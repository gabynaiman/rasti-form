require 'minitest_helper'

describe Rasti::Form::Types::Form do

  form = Rasti::Form[x: Rasti::Form::Types::Integer, y: Rasti::Form::Types::Integer]

  hash = {x: '1', y: '2'}

  it 'Class' do
    result = Rasti::Form::Types::Form[form].cast hash
    result.must_be_instance_of form
    result.x.must_equal 1
    result.y.must_equal 2
  end

  it 'Inline' do
    type = Rasti::Form::Types::Form[x: Rasti::Form::Types::Integer, y: Rasti::Form::Types::Integer]
    result = type.cast hash
    result.must_be_instance_of type.form_class
    result.x.must_equal 1
    result.y.must_equal 2
  end

  it 'Invalid form class' do
    error = proc { Rasti::Form::Types::Form[1] }.must_raise ArgumentError
    error.message.must_equal 'Invalid form specification: 1'
  end

  [nil, 'text', :symbol, 1, [1,2], Object.new].each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::Form[form].cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> #{Rasti::Form::Types::Form[form]}"
    end
  end

  it '{x: "text"} -> ValidationError' do
    error = proc { Rasti::Form::Types::Form[form].cast x: 'test' }.must_raise Rasti::Form::ValidationError
    error.message.must_equal "Validation error: #<Rasti::Form[]> {\"x\":[\"Invalid cast: 'test' -> Rasti::Form::Types::Integer\"]}"
  end

end