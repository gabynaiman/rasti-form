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
        end

        def valid?(value)
          values.include? String.cast(value)
        rescue
          false
        end

        def transform(value)
          String.cast value
        end

      end
    end
  end
end