module Isy
  module Context
    class Action
      attr_reader :id, :component, :block

      def initialize(uuid, component, block)
        @uuid, @component, @block = uuid, component, block
      end

      def call
        Isy.logger.info "component #{component.class} action #{block.source_location.join(':')}"
        component.send(:instance_eval, &block)
      end
    end
  end
end
