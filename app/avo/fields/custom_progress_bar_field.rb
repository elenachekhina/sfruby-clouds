# claude
module Avo
  module Fields
    class CustomProgressBarField < BaseField
      attr_reader :max_attribute
      attr_reader :step
      attr_reader :display_value
      attr_reader :value_suffix

      def initialize(name, **args, &block)
        super(name, **args, &block)

        @max_attribute = args[:max] || 100
        @step = args[:step] || 1
        @display_value = args[:display_value] || false
        @value_suffix = args[:value_suffix] || nil
      end

      def max
        case @max_attribute
        when Symbol
          # If it's a symbol, get the value from the record
          record.public_send(@max_attribute) if record.respond_to?(@max_attribute)
        when Proc
          # If it's a proc, call it with the record
          @max_attribute.call(record)
        else
          # Otherwise use it directly (number or string)
          @max_attribute
        end
      end
    end
  end
end