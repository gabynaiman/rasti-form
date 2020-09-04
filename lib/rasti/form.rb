require 'json'
require 'multi_require'

module Rasti
  class Form

    extend MultiRequire

    require_relative_pattern 'form/*'
    require_relative_pattern 'form/types/*'

    include Validable

    class << self

      def [](attributes)
        Class.new(self) do
          attributes.each do |name, type, options={}|
            attribute name, type, options
          end
        end
      end

      def inherited(subclass)
        subclass.instance_variable_set :@attributes, attributes.dup
      end

      def attribute(name, type, options={})
        attributes[name.to_sym] = options.merge(type: type)
        attr_reader name
      end

      def attributes
        @attributes ||= {}
      end

      def attribute_names
        attributes.keys
      end

      def to_s
        "#{name || self.superclass.name}[#{attribute_names.map(&:inspect).join(', ')}]"
      end
      alias_method :inspect, :to_s

    end

    def initialize(attrs={})
      assign_attributes attrs
      set_defaults
      validate!
    end

    def to_s
      "#<#{self.class.name || self.class.superclass.name}[#{to_h.map { |n,v| "#{n}: #{v.inspect}" }.join(', ')}]>"
    end
    alias_method :inspect, :to_s

    def attributes(options={})
      attributes_filter = {only: assigned_attribute_names, except: []}.merge(options)
      (attributes_filter[:only] - attributes_filter[:except]).each_with_object({}) do |name, hash|
        hash[name] = serialize(read_attribute(name))
      end
    end
    
    def to_h
      attributes
    end

    def assigned?(name)
      assigned_attribute_names.include? name
    end

    def ==(other)
      other.kind_of?(self.class) && other.attributes == attributes
    end

    def eql?(other)
      other.instance_of?(self.class) && other.attributes == attributes
    end

    def hash
      [self.class, attributes].hash
    end

    private

    def assign_attributes(attrs={})
      attrs.each do |name, value|
        attr_name = name.to_sym
        begin
          if self.class.attributes.key? attr_name
            write_attribute attr_name, value
          else
            errors[attr_name] << 'unexpected attribute'
          end
        
        rescue CastError => error
          errors[attr_name] << error.message
        
        rescue MultiCastError, ValidationError => error
          error.errors.each do |inner_name, inner_errors| 
            inner_errors.each { |message| errors["#{attr_name}.#{inner_name}"] << message }
          end
        end        
      end
    end

    def set_defaults
      (self.class.attribute_names - attributes.keys).each do |name|
        if self.class.attributes[name].key? :default
          value = self.class.attributes[name][:default]
          write_attribute name, value.is_a?(Proc) ? value.call(self) : value
        end
      end
    end

    def assigned_attribute_names
      self.class.attribute_names & instance_variables.map { |v| v.to_s[1..-1].to_sym }
    end

    def serialize(value)
      if value.kind_of? Array
        value.map { |v| serialize v }
      elsif value.kind_of? Form
        value.attributes
      else
        value
      end
    end

    def read_attribute(name)
      instance_variable_get "@#{name}"
    end

    def write_attribute(name, value)
      typed_value = value.nil? ? nil : self.class.attributes[name][:type].cast(value)
      instance_variable_set "@#{name}", typed_value
    end

    def fetch(attribute)
      attribute.to_s.split('.').inject(self) do |target, attr_name|
        target.nil? ? nil : target.public_send(attr_name)
      end
    end

    def assert_present(attribute)
      assert attribute, !fetch(attribute).nil?, 'not present' unless errors.key? attribute
    end

    def assert_not_present(attribute)
      assert attribute, fetch(attribute).nil?, 'is present'
    end

    def assert_not_empty(attribute)
      if assert_present attribute
        value = fetch attribute
        assert attribute, value.is_a?(String) ? !value.strip.empty? : !value.empty?, 'is empty'
      end
    end

    def assert_time_range(attribute_from, attribute_to)
       assert attribute_from, public_send(attribute_from) <= public_send(attribute_to), 'invalid time range'
    end

    def assert_included_in(attribute, set)
      if assert_present attribute
        assert attribute, set.include?(fetch(attribute)), "not included in #{set.map { |e| e.is_a?(::String) ? "'#{e}'" : e.inspect }.join(', ')}"
      end
    end

  end
end