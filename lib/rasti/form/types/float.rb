module Rasti
  class Form
    module Types
      class Float
        class << self

          include Castable

          FORMAT = /^(\d+\.)?\d+$/
        
          private

          def valid?(value)
            !value.nil? && (valid_string?(value) || transformable?(value))
          end

          def transform(value)
            value.to_f
          end

          def valid_string?(value)
            value.is_a?(::String) && value.match(FORMAT)
          end

          def transformable?(value)
            !value.is_a?(::String) && value.respond_to?(:to_f)
          end

        end
      end
    end
  end
end