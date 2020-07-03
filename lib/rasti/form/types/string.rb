module Rasti
  class Form
    module Types
      class String
        class << self

          include Castable

          def [](format)
            Class.new(self) do
              @format = format.is_a?(::String) ? ::Regexp.new(format) : format
            end
          end

          def to_s
            name || "#{superclass.name}[#{format.inspect}]"
          end
          alias_method :inspect, :to_s

          private

          attr_reader :format

          def valid?(value)
            !value.nil? && value.respond_to?(:to_s) && valid_format?(value)
          end

          def valid_format?(value)
            format.nil? || !value.to_s.match(format).nil?
          end

          def transform(value)
            value.to_s
          end

        end
      end
    end
  end
end