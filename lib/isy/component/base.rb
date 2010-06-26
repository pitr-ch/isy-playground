module Isy
  module Component

    # represents component of a page. The basic logic building blocks of a application.
    class Base

      attr_reader :context

      # @param [Context::Base] context
      def initialize(context)
        @context = context
        initial_state
      end
      
      # {Base} factory method, it adds proper {Context::Base} automatically 
      # @param [] args are passed automatically to +klass+.new
      # @param [Class] klass which is used to create new {Base} instance
      def new(klass, *args)
        klass.new(context, *args)
      end

      # renders html
      def to_s
        (root? ? layout : widget).to_s
      end

      # @return [Widget::Component] return instantiated widget or creates one
      def widget
        @widget ||= self.class.widget_class.new(self, *widget_args)
      end

      # asks a +component+ for something and executes +block+ when answer is obtained
      # @param [Class, Base] component which is asked
      # @param [] args for {Base} constructor when a Class is passed to +component+
      # yield [Object] answer block which is executed after answer is obtained
      # @example with a {Base} class
      #   ask Counter, 0 do |answer|
      #     values << answer
      #   end
      # @example with a {Base} instance
      #   ask self.counter do |answer|
      #     values << answer
      #   end
      def ask(component, *args, &block)
        component = new(component, *args) if component.kind_of? Class
        component.answering!(self, &block)
        component
      end

      # sets component to answer +to_whom+
      # @param [Base] to_whom
      # @yield block to execute after answer
      # @see #ask
      def answering!(to_whom, &block)
        @asker, @askers_callback = to_whom, block
      end

      # answers with +answer+
      # @param [Object] answer passed to stored block
      # @see #ask
      def answer!(answer = nil)
        @asker.instance_exec answer, &@askers_callback
      end

      protected

      # @return [Class] which is used to insatiate widget
      def self.widget_class
        self._widget_class || @widget_class ||= begin
          "#{self.to_s}::Widget".constantize
        rescue NameError
          "#{self.to_s}Widget".constantize
        end
      end

      # when {Base} is initialized this method is called to setup initial state of the {Base}
      def initial_state
      end

      # @return [Class] which is used to insatiate widget
      def widget_class
        options[:widget_class] || self.class.widget_class
      end

      def widget_args
      end

      private

      class_inheritable_accessor :_widget_class, :instance_writer => false, :instance_reader => false

      # sets widget class
      # @see #widget_class
      # @see .widget_class
      # @param [Class] klass
      def self.set_widget_class(klass)
        self._widget_class = klass
      end

    end
  end
end
