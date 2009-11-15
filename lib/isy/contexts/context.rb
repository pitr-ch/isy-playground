module Isy
  module Contexts

    class Context
      attr_reader :id, :layout, :root_component

      # id, layout class, root_component class
      def initialize(id, root_component_class)
        @id = id
        @root_component = root_component_class.new(nil, self)
        @actions = {}
      end

      def to_s
        @root_component.to_s
      end

      def register_action(component, &block)
        uuid = UUID.generate(:compact)
        @actions[uuid] = Action.new(uuid, component, block)
        return uuid
      end

      def run_action(id)
        @actions[id] && begin
          @actions[id].call
        end
        @actions = {}
      end

    end
  end
end