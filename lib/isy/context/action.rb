module Isy
  module Context

    # represents action which are stored when link is added and evaluated on link click
    class Action
      attr_reader :id, :component, :block

      # @param [String] uuid unique identification
      # @param [Component::Base] component
      # @param [Proc] block which is evaluated on link click
      def initialize(uuid, component, block)
        @uuid, @component, @block = uuid, component, block
      end

      # executes action
      def call
        Isy.logger.debug "component #{component.class} action #{block.source_location.join(':')}"
        component.send(:instance_eval, &block)
      end
    end
  end
end
