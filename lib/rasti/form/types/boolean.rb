module Rasti
  class Form
    module Types
      class Boolean
        class << self

          include Castable

          TRUE_FORMAT  = /^t(rue)?$/i
          FALSE_FORMAT = /^f(alse)?$/i
        
          private

          def valid?(value)
            boolean?(value) || valid_string?(value)
          end

          def transform(value)
            boolean?(value) ? value : true_string?(value)
          end

          def boolean?(value)
            value == true || value == false
          end

          def valid_string?(value)
            value.is_a?(::String) && (true_string?(value) || false_string?(value))
          end

          def true_string?(value)
            !!value.match(TRUE_FORMAT)
          end

          def false_string?(value)
            !!value.match(FALSE_FORMAT)
          end

        end
      end
    end
  end
end