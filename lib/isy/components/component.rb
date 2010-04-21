module Isy
  module Components
    class Component

      attr_reader :context

      def initialize(context)
        @context = context
        initial_state
      end

      def new(klass, *args)
        klass.new(context, *args)
      end

      def to_s
        (root? ? layout : widget).to_s
      end

      def widget
        @widget ||= self.class.widget_class.new(*widget_args)
      end

      def ask(component, *args, &block)
        component = new(component, *args) if component.kind_of? Class
        component.answering!(self, &block)
        component
      end

      def answering!(to_whom, &block)
        @asker, @askers_callback = to_whom, block
      end

      def answer!(answer = nil)
        @asker.instance_exec answer, &@askers_callback
      end

      protected
      
      def self.widget_class
        self._widget_class || @widget_class ||= begin
          "#{self.to_s}::Widget".constantize
        rescue NameError
          "#{self.to_s}Widget".constantize
        end
      end
      
      def self.layout_class
        self._layout_class || @layout_class ||= begin
          "#{self.to_s}::Layout".constantize
        rescue NameError
          "#{self.to_s}Layout".constantize
        end
      end

      def initial_state
      end

      def widget_class
        self.class.widget_class
      end

      def widget_args
        [self]
      end

      private

      class_inheritable_accessor :_widget_class, :instance_writer => false, :instance_reader => false
      class_inheritable_accessor :_layout_class, :instance_writer => false, :instance_reader => false

      def self.set_widget_class(klass)
        self._widget_class = klass
      end

      def self.set_layout_class(klass)
        self._layout_class = klass
      end

    end
  end
end