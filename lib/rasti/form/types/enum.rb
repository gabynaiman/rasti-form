module Rasti
  class Form
    module Types
      class Enum

        include Castable

        attr_reader :values

        def self.[](*values)
          new values
        end

        def to_s
          "#{self.class}[#{values.map(&:inspect).join(', ')}]"
        end
        alias_method :inspect, :to_s

        private

        def initialize(values)
          @values = values.map(&:to_s)
          define_getters
        end

        def valid?(value)
          values.include? String.cast(value)
        rescue
          false
        end

        def transform(value)
          String.cast value
        end

        def define_getters
          values.each do |value|
            getter_name = value.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z])([A-Z])/, '\1_\2').downcase
            define_singleton_method getter_name do
              value
            end
          end
        end

      end
    end
  end
end