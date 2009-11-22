module Isy
  module Contexts
    class Container

      def initialize()
        @contexts = {}
      end

      def [](id)
        @contexts[id]
      end

      def new_context(root_component)
        id = UUID.generate(:compact)
        @contexts[id] = Context.new(id, root_component)
      end

      def size
        @contexts.size
      end
      
    end
  end
end
