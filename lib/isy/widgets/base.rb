module Isy
  module Widgets
    class Base < Erector::Widget

      attr_reader :component

      def initialize(component)
        @component = component
      end

      def widget(target, assigns = {}, &block)
        super(target.kind_of?(Isy::Components::Component) ? target.widget : target, assigns, &block)
      end
      
    end
  end
end