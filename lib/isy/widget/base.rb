module Isy
  module Widget
    class Base < Erector::Widget

      attr_reader :component

      def initialize(component)
        @component = component
      end

      def widget(target, assigns = {}, &block)
        super(target.kind_of?(Isy::Component::Base) ? target.widget : target, assigns, &block)
      end

      def link_to(text, &block)
        uuid = register_action(&block)
        url = { :href => "?context_id=#{component.context.id}&action_id=#{uuid}" }
        a text, url
      end

      private

      def register_action(&block)
        component.context.register_action(component, &block)
      end
      
    end
  end
end