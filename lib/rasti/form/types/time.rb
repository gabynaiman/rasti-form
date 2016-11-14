module Rasti
  class Form
    module Types
      class Time

        include Castable

        attr_reader :format

        def self.[](format)
          new format
        end

        def to_s
          "#{self.class}['#{format}']"
        end
        alias_method :inspect, :to_s

        private

        def initialize(format)
          @format = format
        end

        def valid?(value)
          value.is_a?(::String) || value.respond_to?(:to_time)
        end

        def transform(value)
          value.is_a?(::String) ? string_to_time(value) : value.to_time
        end

        def string_to_time(value)
          ::Time.strptime(value, format)
        end

      end
    end
  end
end