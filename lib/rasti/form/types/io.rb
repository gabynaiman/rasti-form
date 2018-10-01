module Rasti
  class Form
    module Types
      class IO
        class << self

          include Castable
        
          private

          def valid?(value)
            value.respond_to?(:read) && value.respond_to?(:write)
          end

          def transform(value)
            value
          end

        end
      end
    end
  end
end