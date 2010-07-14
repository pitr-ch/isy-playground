# encoding: UTF-8

module Isy
  module Widget

    # Abstract class of all widgets
    class Base < Erector::Widget

      # try to obtain widget and render it with Erector::Widget#widget
      # @param [Erector::Widget, #widget] obj to render
      def render(obj)
        widget begin
          if obj.kind_of?(Erector::Widget)
            obj
          elsif obj.respond_to?(:widget)
            obj.widget
          else
            raise ArgumentError, obj.inspect
          end
        end
      end

      # Wraps widget with element set by .wrap_in. Method is called automatically use #content.
      def content_with_wrapper
        if self.class.wrapped_in
          send self.class.wrapped_in, wrapper_options do
            content
          end
        else
          content
        end
      end

      def to_html(options = {})
        super options.merge(:content_method_name => :content_with_wrapper) {|_,old,_| old }
      end

      class_inheritable_accessor :wrapper

      # @param [Symbol] element which will by used to wrap widget
      def self.wrap_in(element)
        self.wrapper = element
      end

      # @return [Symbol] element which will by used to wrap widget
      def self.wrapped_in
        self.wrapper
      end

      protected

      def wrapper_options
        { :class => self.class.css_class, :id => object_id }
      end

      def _render_via(parent, options = {}, &block)
        super parent, options.merge(:content_method_name => :content_with_wrapper) {|_,old,_| old }, &block
      end

      private

      # @return [String] class name transformed into CSS class, used by #content_with_wrapper
      def self.css_class
        @css_class ||= self.to_s.to_s.underscore.gsub '/', '-'
      end
      
    end
  end
end