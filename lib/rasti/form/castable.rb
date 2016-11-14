module Rasti
  class Form
    module Castable

      def cast(value)
        if valid? value
          transform! value
        else
          raise CastError.new self, value
        end
      end

      private

      def transform!(value)
        transform value
      rescue ValidationError => ex
        raise ex
      rescue
        raise CastError.new self, value
      end

    end
  end
end