# encoding: UTF-8

module Hammer
  module Component

    # represents component of a page. The basic logic building blocks of a application.
    class Base

      attr_reader :context

      # @param [Core::Context] context
      def initialize(context)
        @context = context
        initial_state
      end
      
      # {Base} factory method, it adds proper {Core::Context} automatically
      # @param [] args are passed automatically to +klass+.new
      # @param [Class] klass which is used to create new {Base} instance
      def new(klass, *args)
        klass.new(context, *args)
      end

      # renders html
      def to_html
        @passed_on ? @passed_on.to_html : widget.to_html
      end

      # @return [Widget::Component] return instantiated widget or creates one
      def widget
        @widget ||= create_widget
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
      # @return [Base] created or passed component
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

      # rendering is passed on to +component+. Usually used with ask.
      # @return [Base] 
      # @example 
      #   pass_on ask(Login, Model::User.new) { |user|
      #     do_something_with_returned_user
      #     retake_control!
      #   }
      def pass_on(component)
        @passed_on = component
      end

      # see {#pass_on}
      def retake_control!
        @passed_on = nil
      end

      def inspector(obj, label = nil, packed = true)
        new(inspector_class(obj.class), obj, label, packed)
      end

      protected

      # when {Base} is initialized this method is called to setup initial state of the {Base}
      def initial_state
      end

      def create_widget        
        self.class.widget_class.new(widget_assigns)
      end

      class_inheritable_accessor :_widget_class, :instance_writer => false, :instance_reader => false

      # @return [Class] which is used to insatiate widget
      def self.widget_class
        self._widget_class || 
            self.const_get(:Widget) ||
            self.superclass.widget_class ||
            raise(MissingWidgetClass, "for #{self}")
      end

      # default widget's assignments
      def widget_assigns
        {:component => self}
      end

      private

      # sets widget class
      # @see #widget_class
      # @param [Class] klass
      def self.use_widget_class(klass)
        self._widget_class = klass
      end

      # @return [Class] suitable inspector class for +klass+
      # @param [Class] klass to inspect
      def inspector_class(klass)
        raise ArgumentError, klass.inspect unless klass && klass.kind_of?(Class)
        "Hammer::Component::Developer::Inspection::#{klass}".constantize
      rescue NameError
        inspector_class(klass.superclass)
      end

    end
  end
end
