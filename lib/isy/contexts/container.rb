module Isy
  module Contexts
    class Container

      def initialize()
        @contexts = {}
      end

      def [](id)
        @contexts[id]
      end

      def new_context(layout, root_component)
        id = Isy.generate_id
        @contexts[id] = Context.new(id, layout, root_component)
      end

      def size
        @contexts.size
      end
      
    end
  end
end
