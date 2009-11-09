module Erector
  class Component < Widget

    attr_accessor :app_context

    def a(action_block, *args, &block)
      uuid = app_context.register_action(self, &action_block)

      url = { :href => "?action=#{uuid}" }
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
  end
end