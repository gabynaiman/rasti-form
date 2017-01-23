require 'minitest_helper'

describe Rasti::Form do
  
  let(:point_class) { Rasti::Form[x: Rasti::Form::Types::Integer, y: Rasti::Form::Types::Integer] }

  let(:point_subclass) { Class.new point_class }
  
  def build_form(&block)
    Class.new(Rasti::Form) do
      class_eval &block
    end
  end

  describe 'Initialization' do

    it 'All attributes' do
      point = point_class.new x: 1, y: 2
      point.x.must_equal 1
      point.y.must_equal 2
      point.assigned?(:x).must_equal true
      point.assigned?(:y).must_equal true
    end

    it 'Some attributes' do
      point = point_class.new x: 1
      point.x.must_equal 1
      point.y.must_be_nil
      point.assigned?(:x).must_equal true
      point.assigned?(:y).must_equal false
    end

    it 'Whitout attributes' do
      point = point_class.new
      point.x.must_be_nil
      point.y.must_be_nil
      point.assigned?(:x).must_equal false
      point.assigned?(:y).must_equal false
    end

    it 'Extra attributes' do
      point = point_class.new z: 3
      point.x.must_be_nil
      point.y.must_be_nil
      point.assigned?(:x).must_equal false
      point.assigned?(:y).must_equal false
      proc { point.z }.must_raise NoMethodError
      point.attributes.must_be_empty
    end

    describe 'Casting' do

      it 'Attribute' do
        form = build_form do
          attribute :text, Rasti::Form::Types::String
        end

        f = form.new text: 123
        f.text.must_equal "123"
      end

      it 'Nested attributes' do
        form = build_form do
          attribute :range, Rasti::Form::Types::Form[min: Rasti::Form::Types::Integer, max: Rasti::Form::Types::Integer]
        end

        f = form.new range: {min: '1', max: '10'}
        f.range.min.must_equal 1
        f.range.max.must_equal 10
      end

      it 'Nested form' do
        range = build_form do
          attribute :min, Rasti::Form::Types::Integer
          attribute :max, Rasti::Form::Types::Integer
        end

        form = build_form do
          attribute :range, Rasti::Form::Types::Form[range]
        end

        f = form.new range: {min: '1', max: '10'}
        f.range.min.must_equal 1
        f.range.max.must_equal 10
      end

      it 'Invalid attributes' do
        form = build_form do
          attribute :boolean, Rasti::Form::Types::Boolean
          attribute :number, Rasti::Form::Types::Integer
        end

        error = proc { form.new boolean: 'x', number: 'y' }.must_raise Rasti::Form::ValidationError
        error.message.must_equal 'Validation error: {"boolean":["Invalid cast: \'x\' -> Rasti::Form::Types::Boolean"],"number":["Invalid cast: \'y\' -> Rasti::Form::Types::Integer"]}'
      end

      it 'Invalid nested attributes' do
        form = build_form do
          attribute :range, Rasti::Form::Types::Form[min: Rasti::Form::Types::Integer, max: Rasti::Form::Types::Integer]
        end

        error = proc { form.new range: {min: 'x', max: 'y'} }.must_raise Rasti::Form::ValidationError
        error.message.must_equal "Validation error: {\"range.min\":[\"Invalid cast: 'x' -> Rasti::Form::Types::Integer\"],\"range.max\":[\"Invalid cast: 'y' -> Rasti::Form::Types::Integer\"]}"
      end

      it 'Invalid form attributes' do
        range = build_form do
          attribute :min, Rasti::Form::Types::Integer
          attribute :max, Rasti::Form::Types::Integer
        end

        form = build_form do
          attribute :range, Rasti::Form::Types::Form[range]
        end

        error = proc { form.new range: {min: 'x', max: 'y'} }.must_raise Rasti::Form::ValidationError
        error.message.must_equal "Validation error: {\"range.min\":[\"Invalid cast: 'x' -> Rasti::Form::Types::Integer\"],\"range.max\":[\"Invalid cast: 'y' -> Rasti::Form::Types::Integer\"]}"
      end

    end

  end

  describe 'Defaults' do

    it 'Value' do
      form = build_form do
        attribute :text, Rasti::Form::Types::String, default: 'xyz'
      end

      f = form.new
      f.text.must_equal 'xyz'
    end

    it 'Block' do
      form = build_form do
        attribute :time_1, Rasti::Form::Types::Time['%F']
        attribute :time_2, Rasti::Form::Types::Time['%F'], default: ->(f) { f.time_1 }
      end

      f = form.new time_1: Time.now
      f.time_2.must_equal f.time_1
    end

  end

  describe 'Validations' do

    it 'Required' do
      form = build_form do
        attribute :text, Rasti::Form::Types::String

        def validate
          assert_present :text
        end
      end

      error = proc { form.new }.must_raise Rasti::Form::ValidationError
      error.message.must_equal 'Validation error: {"text":["not present"]}'
    end

    it 'Not empty string' do
      form = build_form do
        attribute :text, Rasti::Form::Types::String

        def validate
          assert_not_empty :text
        end
      end

      error = proc { form.new text: '  ' }.must_raise Rasti::Form::ValidationError
      error.message.must_equal 'Validation error: {"text":["is empty"]}'
    end

    it 'Not empty array' do
      form = build_form do
        attribute :array, Rasti::Form::Types::Array[Rasti::Form::Types::String]

        def validate
          assert_not_empty :array
        end
      end

      error = proc { form.new array: [] }.must_raise Rasti::Form::ValidationError
      error.message.must_equal 'Validation error: {"array":["is empty"]}'
    end

    it 'Included in values list' do
      form = build_form do
        attribute :text, Rasti::Form::Types::String

        def validate
          assert_included_in :text, %w(value_1 value_2)
        end
      end

      error = proc { form.new text: 'xyz' }.must_raise Rasti::Form::ValidationError
      error.message.must_equal 'Validation error: {"text":["not included in \'value_1\', \'value_2\'"]}'
    end

    it 'Nested form' do
      form = build_form do
        attribute :range, Rasti::Form::Types::Form[min: Rasti::Form::Types::Integer, max: Rasti::Form::Types::Integer]

        def validate
          assert_present 'range.min'
          assert_present 'range.max'
        end
      end

      error = proc { form.new }.must_raise Rasti::Form::ValidationError
      error.message.must_equal 'Validation error: {"range.min":["not present"],"range.max":["not present"]}'
    end

    it 'Nested validation' do
      range = build_form do
        attribute :min, Rasti::Form::Types::Integer
        attribute :max, Rasti::Form::Types::Integer

        def validate
          assert :min, min < max, 'Min must be less than Max' if min && max
        end
      end

      form = build_form do
        attribute :range, Rasti::Form::Types::Form[range]
      end 

      error = proc { form.new range: {min: 2, max: 1} }.must_raise Rasti::Form::ValidationError
      error.message.must_equal 'Validation error: {"range.min":["Min must be less than Max"]}'
    end

  end

  describe 'Comparable' do

    it 'Equivalency (==)' do
      point_1 = point_class.new x: 1, y: 2
      point_2 = point_subclass.new x: 1, y: 2
      point_3 = point_class.new x: 2, y: 1

      assert point_1 == point_2
      refute point_1 == point_3
    end
    
    it 'Equality (eql?)' do
      point_1 = point_class.new x: 1, y: 2
      point_2 = point_class.new x: 1, y: 2
      point_3 = point_subclass.new x: 1, y: 2
      point_4 = point_class.new x: 2, y: 1

      assert point_1.eql?(point_2)
      refute point_1.eql?(point_3)
      refute point_1.eql?(point_4)
    end

    it 'hash' do
      point_1 = point_class.new x: 1, y: 2
      point_2 = point_class.new x: 1, y: 2
      point_3 = point_subclass.new x: 1, y: 2
      point_4 = point_class.new x: 2, y: 1

      point_1.hash.must_equal point_2.hash
      point_1.hash.wont_equal point_3.hash
      point_1.hash.wont_equal point_4.hash
    end

  end

  it 'Attributes (to_h)' do
    t = Rasti::Form::Types
    address_class = Rasti::Form[street: t::String, number: t::Integer]
    contact_class = Rasti::Form[
      name: t::String, 
      age: t::Integer, 
      phones: t::Hash[t::Symbol, t::Integer], 
      addresses: t::Array[t::Form[address_class]]
    ]

    attributes = {
      name: 'John', 
      age: 24, 
      phones: {
        office: 1234567890, 
        house:  456456456
      },
      addresses: [
        {street: 'Lexington Avenue', number: 123},
        {street: 'Park Avenue',      number: 456}
      ]
    }

    contact = contact_class.new attributes

    contact.attributes.must_equal attributes
    contact.attributes.must_equal contact.to_h
  end

  it 'to_s' do
    point_class.to_s.must_equal 'Rasti::Form[:x, :y]'
    point_class.new(x: '1', y: '2').to_s.must_equal '#<Rasti::Form[x: 1, y: 2]>'
  end

  it 'Subclass' do
    point = point_subclass.new x: 1, y: 2
    point.x.must_equal 1
    point.y.must_equal 2
  end

end