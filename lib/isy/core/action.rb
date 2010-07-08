# encoding: UTF-8

module Isy
  module Core

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
        Isy.benchmark "Running action #{block.source_location.join(':')}" do
          component.send(:instance_eval, &block)
        end
      end
    end
  end
end
