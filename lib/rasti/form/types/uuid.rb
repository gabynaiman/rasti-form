module Rasti
  class Form
    module Types
      class UUID
        class << self

          include Formatable

          private

          def format
            /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}+$/
          end

        end
      end
    end
  end
end