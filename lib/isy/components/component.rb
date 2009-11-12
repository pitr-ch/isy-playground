module Isy
  module Components
    class Component < Erector::Widget

      attr_accessor :app_context

      def a(action_block, *args, &block)
        uuid = register_action(action_block)

        url = { :href => "/do-action/#{uuid}" }
        if args.last.is_a?(Hash)
          args.last.merge url
        else
          args.push url
        end

        super(*args, &block)
      end

      def app_context
        @app_context ||= parent.app_context
      end

      private

      def register_action(block)
        app_context.register_action(self, &block)
      end
    end
  end
end