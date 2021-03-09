module Rasti
  class Form
    module Validable

      private

      def errors
        @errors ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def validate!
        validate
        raise ValidationError.new(self, errors) unless errors.empty?
      end

      def validate
      end

      def assert(key, condition, message)
        errors[key] << message unless condition
        condition
      end

      def assert_not_error(key)
        yield
        true
      rescue => ex
        errors[key] << ex.message
        false
      end

    end
  end
end
