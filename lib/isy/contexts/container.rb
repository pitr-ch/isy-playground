module Isy
  module Contexts
    class Container

      def initialize()
        @contexts = {}
      end

      def [](id)
        @contexts[id]
      end

      def new_context(id, root_component)
        @contexts[id] = Context.new(id, root_component)
      end
      
    end
  end
end
