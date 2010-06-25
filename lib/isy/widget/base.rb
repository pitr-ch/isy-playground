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
            raise ArgumentError
          end
        end
      end
      
    end
  end
end