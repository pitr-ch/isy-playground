module Isy
  module Widgets
    class Layout < Erector::Widgets::Page

      def initialize(context)
        @context = context
      end

      def body_content
        widget @context.root_component.widget
      end

    end
  end
end