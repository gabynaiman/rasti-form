module Rasti
  class Form
    module Types
      class String
        class << self

          include Castable
        
          private

          def valid?(value)
            !value.nil? && value.respond_to?(:to_s)
          end

          def transform(value)
            value.to_s
          end

        end
      end
    end
  end
end