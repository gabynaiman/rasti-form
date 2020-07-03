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
        return true if condition
        
        errors[key] << message
        false
      end

      def assert_not_error(key)
        yield
        true
      rescue => error
        assert key, false, error.message
      end

    end
  end
end
