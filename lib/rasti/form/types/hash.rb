module Rasti
  class Form
    module Types
      class Hash
        
        include Castable

        attr_reader :key_type, :value_type

        def self.[](key_type, value_type)
          new key_type, value_type
        end

        def to_s
          "#{self.class}[#{key_type}, #{value_type}]"
        end
        alias_method :inspect, :to_s

        private

        def initialize(key_type, value_type)
          @key_type = key_type
          @value_type = value_type
        end

        def valid?(value)
          value.is_a? ::Hash
        end

        def transform(value)
          value.each_with_object({}) do |(k,v),h| 
            h[key_type.cast k] = value_type.cast v
          end
        end

      end
    end
  end
end