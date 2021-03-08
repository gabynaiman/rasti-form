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

      def assert(key, *args)
        message = block_given? ? args[0] : args[1]
        condition = block_given? ? yield : args[0]

        errors[key] << message unless condition
        condition

      rescue Model::NotAssignedAttributeError, Types::CastError, Types::CompoundError
        errors[key] << message
        false
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
