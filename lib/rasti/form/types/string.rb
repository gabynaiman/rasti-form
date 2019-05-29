module Rasti
  class Form
    module Types
      class String

        include Formatable

        class << self

          include Castable

          def [](format)
            new format
          end

          private

          def valid?(value)
            !value.nil? && value.respond_to?(:to_s)
          end

          def transform(value)
            value.to_s
          end

        end

        def to_s
          "#{self.class}[#{format.inspect}]"
        end
        alias_method :inspect, :to_s

        private
        
        attr_reader :format

        def initialize(format)
          @format = format.is_a?(String) ? ::Regexp.new(format) : format
        end

      end
    end
  end
end