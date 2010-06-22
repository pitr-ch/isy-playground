module Isy
  module Context

    class Base
      attr_reader :id, :layout, :root_component

      # id, layout class, root_component class
      def initialize(id, layout, root_component_class)
        @id = id
        @root_component = root_component_class.new(self)
        @layout = layout.new(self)
        clear_actions
      end

      def to_s
        layout.to_s
      end

      def register_action(component, &block)
        uuid = Isy.generate_id
        @actions[uuid] = Action.new(uuid, component, block)
        return uuid
      end

      def run_action(id)
        (action = @actions[id]) && action.call
        clear_actions
      end

      private

      def clear_actions
        @actions = {}
      end

    end
  end
end