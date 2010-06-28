module Isy
  module Widget

    # Abstract layout for Isy applications
    class Layout < Erector::Widgets::Page

      # @param [Context::Base] context which is rendered with this layout
      def initialize(context)
        super()
        @context = context
      end

      # after rendering itself it renders root component into body
      def body_content
        widget @context.root_component.widget
      end

    end
  end
end