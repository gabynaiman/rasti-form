module Rasti
  class Form
    module Types
      class Form

        include Castable

        attr_reader :form_class

        def self.[](*args)
          new *args
        end

        def to_s
          "#{self.class}[#{form_class}]"
        end
        alias_method :inspect, :to_s

        private

        def initialize(form)
          @form_class = case
            when form.is_a?(::Hash) then Rasti::Form[form]
            when form.is_a?(Class) && form.ancestors.include?(Rasti::Form) then form
            else raise ArgumentError, "Invalid form specification: #{form.inspect}"
          end
        end

        def valid?(value)
          value.is_a? ::Hash
        end

        def transform(value)
          form_class.new value
        end

      end
    end
  end
end