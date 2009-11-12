module Isy
  module Contexts
    class Container

      def initialize()
        @contexts = {}
      end

      def [](id)
        @contexts[id]
      end

      def new_context(id, layout, root_component)
        @contexts[id] = Context.new(id, layout, root_component)
      end
      
    end
  end
end
