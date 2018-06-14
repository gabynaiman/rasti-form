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
          result = []
          errors = {}

          value.each_with_index do |e,i|
            index = i + 1
            begin
              result << type.cast(e)
            rescue ValidationError => error
              error.errors.each do |k,v|
                errors["#{index}.#{k}"] = v
              end
            rescue => error
              errors[index] = [error.message]
            end
          end

          raise MultiCastError.new(self, value, errors) unless errors.empty?

          result
        end

      end
    end
  end
end