# claude
module Avo
  module Fields
    class CustomProgressBarField < BaseField
      attr_reader :max_attribute, :step, :display_value, :value_suffix

      def initialize(name, **args, &block)
        super(name, **args, &block)

        @max_attribute = args.fetch(:max, 100)
        @step = args.fetch(:step, 1)
        @display_value = args.fetch(:display_value, false)
        @value_suffix = args[:value_suffix]
      end

      def max
        resolve_value(@max_attribute)
      end

      private

      def resolve_value(value)
        case value
        when Symbol
          record.public_send(value) if record&.respond_to?(value)
        when Proc
          value.call(record)
        else
          value
        end
      end
    end
  end
end
