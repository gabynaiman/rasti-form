require 'minitest_helper'

describe Rasti::Form, 'Validations' do

  def build_form(&block)
    Class.new(Rasti::Form) do
      class_eval(&block)
    end
  end

  def assert_validation_error(expected_errors, &block)
    error = proc { block.call }.must_raise Rasti::Form::ValidationError
    error.errors.must_equal expected_errors
  end

  it 'Validation error message' do
    scope = Object.new
    errors = {
      x: ['not present'],
      y: ['error 1', 'error 2']
    }

    error = Rasti::Form::ValidationError.new scope, errors

    error.scope.must_equal scope
    error.errors.must_equal errors
    error.message.must_equal "Validation errors:\n- x: [\"not present\"]\n- y: [\"error 1\", \"error 2\"]"
  end

  it 'Invalid attributes' do
    assert_validation_error(z: ['unexpected attribute']) do
      Rasti::Form[:x, :y].new z: 3
    end
  end

  it 'Not error' do
    form = build_form do
      attribute :text, T::String

      def validate
        assert_not_error :text do
          raise 'invalid text' unless assigned? :text
        end
      end
    end

    proc { form.new text: 'text' }.must_be_silent

    assert_validation_error(text: ['invalid text']) do
      form.new
    end
  end

  describe 'Present' do

    let :form do
      build_form do
        attribute :number, T::Integer

        def validate
          assert_present :number
        end
      end
    end

    it 'Success' do
      proc { form.new number: 1 }.must_be_silent
    end

    it 'Not assigned' do
      assert_validation_error(number: ['not present']) do
        form.new
      end
    end

    it 'Nil' do
      assert_validation_error(number: ['not present']) do
        form.new number: nil
      end
    end

    it 'Invalid cast' do
      assert_validation_error(number: ['Invalid cast: true -> Rasti::Types::Integer']) do
        form.new number: true
      end
    end

    it 'Invalid nested cast' do
      range = build_form do
        attribute :min, T::Integer
        attribute :max, T::Integer

        def validate
          assert_range :min, :max
        end
      end

      form = build_form do
        attribute :range, T::Model[range]

        def validate
          assert_present :range
        end
      end

      assert_validation_error('range.max' => ['not present']) do
        form.new range: {min: 1}
      end
    end

    it 'With default' do
      form = build_form do
        attribute :number, T::Integer, default: 1

        def validate
          assert_present :number
        end
      end

      proc { form.new }.must_be_silent

      assert_validation_error(number: ['not present']) do
        form.new number: nil
      end
    end

  end

  describe 'Not present' do

    let :form do
      range = build_form do
        attribute :min, T::Integer
        attribute :max, T::Integer

        def validate
          assert_range :min, :max
        end
      end

      build_form do
        attribute :range, T::Model[range]

        def validate
          assert_not_present :range
        end
      end
    end

    it 'Success not assigned' do
      proc { form.new }.must_be_silent
    end

    it 'Success with nil' do
      proc { form.new range: nil }.must_be_silent
    end

    it 'Assigned' do
      assert_validation_error(range: ['is present']) do
        form.new range: {min: 1, max: 2}
      end
    end

    it 'Invalid nested cast' do
      assert_validation_error('range.max' => ['not present']) do
        form.new range: {min: 1}
      end
    end

  end

  describe 'Not empty' do

    it 'Must be present' do
      form = build_form do
        attribute :text, T::String

        def validate
          assert_not_empty :text
        end
      end

      proc { form.new text: 'text' }.must_be_silent

      assert_validation_error(text: ['not present']) do
        form.new text: nil
      end

      assert_validation_error(text: ['not present']) do
        form.new
      end
    end

    it 'String' do
      form = build_form do
        attribute :text, T::String

        def validate
          assert_not_empty :text
        end
      end

      proc { form.new text: 'text' }.must_be_silent

      assert_validation_error(text: ['is empty']) do
        form.new text: ' '
      end
    end

    it 'Array' do
      form = build_form do
        attribute :array, T::Array[T::String]

        def validate
          assert_not_empty :array
        end
      end

      proc { form.new array: ['text'] }.must_be_silent

      assert_validation_error(array: ['is empty']) do
        form.new array: []
      end
    end

    it 'Hash' do
      form = build_form do
        attribute :hash, T::Hash[T::String, T::String]

        def validate
          assert_not_empty :hash
        end
      end

      proc { form.new hash: {key: 'value'} }.must_be_silent

      assert_validation_error(hash: ['is empty']) do
        form.new hash: {}
      end
    end

  end

  it 'Included in values list' do
    form = build_form do
      attribute :text, T::String

      def validate
        assert_included_in :text, %w(value_1 value_2)
      end
    end

    proc { form.new text: 'value_1' }.must_be_silent

    assert_validation_error(text: ['not included in "value_1", "value_2"']) do
      form.new text: 'xyz'
    end
  end

  it 'Time range' do
    form = build_form do
      attribute :from, T::Time['%Y-%m-%d %H:%M:%S']
      attribute :to,   T::Time['%Y-%m-%d %H:%M:%S']

      def validate
        assert_range :from, :to
      end
    end

    from = '2018-01-01 03:10:00'
    to = '2018-01-01 15:30:00'

    proc { form.new from: from, to: to }.must_be_silent

    assert_validation_error(from: ['invalid range']) do
      form.new from: to, to: from
    end
  end

  it 'Nested validation' do
    range = build_form do
      attribute :min, T::Integer
      attribute :max, T::Integer

      def validate
        assert_range :min, :max
      end
    end

    form = build_form do
      attribute :range, T::Model[range]
    end

    proc { form.new range: {min: 1, max: 2} }.must_be_silent

    assert_validation_error('range.min' => ['invalid range']) do
      form.new range: {min: 2, max: 1}
    end
  end

  it 'Invalid cast must be raise as ValidationError' do
    form = build_form do
      attribute :id, T::UUID

      def validate
        id
      end
    end

    assert_validation_error(id: ["Invalid cast: '123' -> Rasti::Types::UUID"]) do
      form.new id: '123'
    end
  end

end