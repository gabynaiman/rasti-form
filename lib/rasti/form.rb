require 'rasti-model'
require 'multi_require'

module Rasti
  class Form < Rasti::Model

    extend MultiRequire

    require_relative_pattern 'form/*'

    include Validable

    def initialize(attributes={})
      begin
        super attributes

        cast_attributes!

      rescue Rasti::Model::UnexpectedAttributesError => ex
        ex.attributes.each do |attr_name|
          errors[attr_name] << 'unexpected attribute'
        end

      rescue Rasti::Types::CompoundError => ex
        ex.errors.each do |key, messages|
          errors[key] += messages
        end

      end

      validate!
    end

    def attributes(*args)
      warn '[Deprecated] Rasti::Form#attributes will be removed next major version (v4.0.0)'
      warn caller_locations(1,1)[0].to_s
      to_h(*args)
    end

    def assigned?(attr_name)
      assigned_attribute? attr_name
    end

    private

    def assert_present(attr_name)
      assert attr_name, !public_send(attr_name).nil?, 'not present' unless errors.key? attr_name
    rescue NotAssignedAttributeError
      assert attr_name, false, 'not present'
    end

    def assert_not_present(attr_name)
      assert attr_name, public_send(attr_name).nil?, 'is present'
    rescue NotAssignedAttributeError
      true
    end

    def assert_not_empty(attr_name)
      if assert_present attr_name
        value = public_send attr_name
        assert attr_name, value.is_a?(String) ? !value.strip.empty? : !value.empty?, 'is empty'
      end
    end

    def assert_included_in(attr_name, set)
      if assert_present attr_name
        assert attr_name, set.include?(public_send(attr_name)), "not included in #{set.map(&:inspect).join(', ')}"
      end
    end

    def assert_range(attr_name_from, attr_name_to)
       assert attr_name_from, public_send(attr_name_from) <= public_send(attr_name_to), 'invalid range'
    end

  end
end