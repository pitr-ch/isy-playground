module Hammer
  module Component
    class FormPart < Component::Base

      attr_accessor :form

      attr_reader :record

      # values from form's tags are stored here. They are automatically updated when :form callback is triggered
      # @return [Object] value for +key+
      # @param [Symbol] key of a value
      def value(key = :value)
        @record.send key
      end

      # @overload set_value(key, value)
      #   Sets a value on key
      #   @param [Symbol] key
      #   @param [Object] value
      # @overload set(value)
      #   Sets a value on the default key :value
      #   @param [Object] value describe value param
      def set_value(*args)
        key, value = args.pop 2
        unless value
          value, key = key, :value
        end
        @record.send "#{key}=", value
      end

      # @param [Object] form Identifies which form parts belongs together. +form+.object_id is used to identify
      def initialize(context, form = self)
        @form = form
        super(context)
      end

      class Widget < Widget::Component
        protected

        def wrapper_options
          super.merge :'data-form-id' => c.form.object_id, :'data-component-id' => c.object_id
        end
      end
    end
  end
end