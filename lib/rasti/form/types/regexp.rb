module Rasti
  class Form
    module Types
      class Regexp
        class << self

          include Castable

          private

          def valid?(value)
            value.is_a?(::Regexp) || value.is_a?(::String)
          end

          def transform(value)
            value.is_a?(::Regexp) ? value.source : ::Regexp.compile(value).source
          end

        end
      end
    end
  end
end