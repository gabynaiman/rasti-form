module Rasti
  class Form
    module Types
      class Symbol
        class << self

          include Castable
        
          private

          def valid?(value)
            !value.nil? && (value.respond_to?(:to_sym) || value.respond_to?(:to_s))
          end

          def transform(value)
            value.respond_to?(:to_sym) ? value.to_sym : value.to_s.to_sym
          end

        end
      end
    end
  end
end