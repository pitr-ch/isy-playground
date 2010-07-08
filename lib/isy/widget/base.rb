# encoding: UTF-8

module Isy
  module Widget

    # Abstract class of all widgets
    class Base < Erector::Widget

      # FIXME monkey patch

      class_inheritable_accessor :content_method_name
      self.content_method_name = :content

      def _render(options = {}, &blk)
        options = {
          :output => "",  # "" is apparently faster than [] in a long-running process
          :prettyprint => prettyprint_default,
          :indentation => 0,
          :helpers => nil,
          :parent => @parent,
          :content_method_name => self.class.content_method_name,
        }.merge(options)
        context(options[:parent], options[:output], options[:prettyprint], options[:indentation], options[:helpers]) do
          send(options[:content_method_name], &blk)
          output
        end
      end

      def write_via(parent)
        context(parent, parent.output, parent.prettyprint, parent.indentation, parent.helpers) do
          send self.class.content_method_name
        end
      end

      # end of monkey patch

      # try to obtain widget and render it with Erector::Widget#widget
      # @param [Erector::Widget, #widget] obj to render
      def render(obj)
        widget begin
          if obj.kind_of?(Erector::Widget)
            obj
          elsif obj.respond_to?(:widget)
            obj.widget
          else
            raise ArgumentError
          end
        end
      end

      # Wraps widget with element set by .wrap_in. Method is called automatically use #content.
      def content_with_wrapper
        send self.class.wrapped_in, wrapper_options do
          content
        end
      end

      self.content_method_name = :content_with_wrapper

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

      private

      # @return [String] class name transformed into CSS class, used by #content_with_wrapper
      def self.css_class
        @css_class ||= self.to_s.to_s.underscore.gsub '/', '-'
      end
      
    end
  end
end