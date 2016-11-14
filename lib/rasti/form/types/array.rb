module Rasti
  class Form
    module Types
      class Array

        include Castable

        attr_reader :type

        def self.[](type)
          new type
        end

        def to_s
          "#{self.class}[#{type}]"
        end
        alias_method :inspect, :to_s

        private

        def initialize(type)
          @type = type
        end

        def valid?(value)
          value.is_a? ::Array
        end

        def transform(value)
          value.map { |e| type.cast e }
        end

      end
    end
  end
end