module Rasti
  class Form
    module Formatable

      include Castable

      private

      def valid?(value)
        (value.is_a?(::String) || value.is_a?(Symbol)) && value.to_s.match(format)
      end

      def transform(value)
        value
      end
      
    end
  end
end
