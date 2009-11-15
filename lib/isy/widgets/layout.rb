module Isy
  module Widgets
    class Layout < Erector::Widgets::Page

      def initialize(root_component)
        @root_component = root_component
      end

      def body_content
        widget @root_component.widget
      end

    end
  end
end