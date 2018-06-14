require 'minitest_helper'

describe Rasti::Form::Types::Array do

  VALID_ARRAY = [1, '2', Time.now]
  INVALID_ARRAY = [nil, 1, 'text', :symbol, {a: 1, b: 2}, Object.new]
  
  it "#{VALID_ARRAY.inspect} -> #{VALID_ARRAY.map(&:to_i)}" do
    Rasti::Form::Types::Array[Rasti::Form::Types::Integer].cast(VALID_ARRAY).must_equal VALID_ARRAY.map(&:to_i)
  end

  it "#{VALID_ARRAY.inspect} -> #{VALID_ARRAY.map(&:to_s)}" do
    Rasti::Form::Types::Array[Rasti::Form::Types::String].cast(VALID_ARRAY).must_equal VALID_ARRAY.map(&:to_s)
  end

  INVALID_ARRAY.each do |value|
    it "#{value.inspect} -> CastError" do
      error = proc { Rasti::Form::Types::Array[Rasti::Form::Types::String].cast(value) }.must_raise Rasti::Form::CastError
      error.message.must_equal "Invalid cast: #{as_string(value)} -> Rasti::Form::Types::Array[Rasti::Form::Types::String]"
    end
  end

  describe 'Multi cast errors' do

    it 'Array of integers' do
      array = [1, 2 , 'a', 3, 'c', 4, nil]
      error = proc { Rasti::Form::Types::Array[Rasti::Form::Types::Integer].cast(array) }.must_raise Rasti::Form::MultiCastError
      error.errors.must_equal 3 => ["Invalid cast: 'a' -> Rasti::Form::Types::Integer"], 
                              5 => ["Invalid cast: 'c' -> Rasti::Form::Types::Integer"],
                              7 => ["Invalid cast: nil -> Rasti::Form::Types::Integer"]
      error.display_value.must_equal "[1, 2, \"a\", 3, \"c\", 4, nil]"
      error.message.must_equal "Invalid cast: [1, 2, \"a\", 3, \"c\", 4, nil] -> Rasti::Form::Types::Array[Rasti::Form::Types::Integer] - {\"3\":[\"Invalid cast: 'a' -> Rasti::Form::Types::Integer\"],\"5\":[\"Invalid cast: 'c' -> Rasti::Form::Types::Integer\"],\"7\":[\"Invalid cast: nil -> Rasti::Form::Types::Integer\"]}"
    end

    it 'Array of forms' do
      inner_form_class = Rasti::Form::Types::Form[x: Rasti::Form::Types::Integer, y: Rasti::Form::Types::Integer]
      form_class = Rasti::Form[points: Rasti::Form::Types::Array[inner_form_class]]

      error = proc do
        form = form_class.new points: [
          {x: 1, y: 2},
          {x: 'a', y: 2},
          {x: 1, y: 'b'},
          {x: 3, y: 4}
        ]
      end.must_raise Rasti::Form::ValidationError

      error.errors.must_equal 'points.2.x' => ["Invalid cast: 'a' -> Rasti::Form::Types::Integer"], 
                              'points.3.y' => ["Invalid cast: 'b' -> Rasti::Form::Types::Integer"]
      error.message.must_equal "Validation error: #<Rasti::Form[]> {\"points.2.x\":[\"Invalid cast: 'a' -> Rasti::Form::Types::Integer\"],\"points.3.y\":[\"Invalid cast: 'b' -> Rasti::Form::Types::Integer\"]}"
    end

  end

end