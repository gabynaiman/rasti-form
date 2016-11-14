module Rasti
  class Form
    module Types
      class Integer < Float
        class << self
        
          private

          def transform(value)
            value.to_i
          end

          def transformable?(value)
            !value.is_a?(::String) && value.respond_to?(:to_i)
          end

        end
      end
    end
  end
end