module Rasti
  class Form

    class ValidationError < Rasti::Types::CompoundError

      attr_reader :scope

      def initialize(scope, errors)
        @scope = scope
        super errors
      end

      private

      def message_title
        'Validation errors:'
      end

    end

  end
end