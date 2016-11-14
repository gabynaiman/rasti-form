module Rasti
  class Form
    
    class CastError < StandardError

      attr_reader :type, :value

      def initialize(type, value)
        @type = type
        @value = value
      end

      def message
        "Invalid cast: #{display_value} -> #{type}"
      end

      private

      def display_value
        value.is_a?(::String) ? "'#{value}'" : value.inspect
      end

    end


    class ValidationError < StandardError

      attr_reader :errors
      
      def initialize(errors)
        @errors = errors
      end

      def message
        "Validation error: #{JSON.dump(errors)}"
      end

    end

  end
end