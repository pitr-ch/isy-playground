module Isy
  module Context

    # represents context of user, each tab of browser has one of its own
    class Base
      attr_reader :id, :layout, :root_component

      # @param [String] id unique identification
      # @param [Widget::Layout] layout is used to render page layout
      # @param [Component::Base] root_component
      def initialize(id, layout, root_component_class)
        @id = id
        @root_component = root_component_class.new(self)
        @layout = layout.new(self)
        clear_actions
      end

      # renders html, similar to Erector::Widget#to_s
      def to_s
        layout.to_s
      end

      # creates and stores action for later evaluation
      # @param [Component::Base] component where action will be evaluated
      # @yield the action
      def register_action(component, &block)
        uuid = Isy.generate_id
        @actions[uuid] = Action.new(uuid, component, block)
        return uuid
      end

      # evaluates action with +id+
      # @param [String] id of a {Action}
      def run_action(id)
        (action = @actions[id]) && action.call
        clear_actions
      end

      private

      # deletes all stored {Action}-s
      def clear_actions
        @actions = {}
      end

    end
  end
end