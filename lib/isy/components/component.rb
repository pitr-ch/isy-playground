module Isy
  module Components
    class Component

      attr_reader :parent, :children, :context

      def initialize(parent_or_context)
        case
        when parent_or_context.kind_of?(Isy::Contexts::Context)
          @parent, @context = nil, parent_or_context
        when parent_or_context.kind_of?(Isy::Components::Component)
          @parent, @context = parent_or_context, parent_or_context.context
        else
          raise(ArgumentError, "parent_or_context is not component or context")
        end

        @children = []
        parent.children << self if parent
        
        initial_state
      end

      def to_s
        (root? ? layout : widget).to_s
      end

      def root?
        parent == nil
      end

      def widget
        @widget ||= self.class.widget_class.new(*widget_args)
      end

      def layout
        raise RuntimeError, 'i am not root' unless root?
        @layout ||= self.class.layout_class.new(self)
      end

      def remove
        @parent.children.delete self
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