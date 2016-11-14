module Rasti
  class Form
    module Types
      class Regexp

        include Formatable

        def self.[](format)
          new format
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