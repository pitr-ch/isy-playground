module Isy
  module Context

    # Manages all context of one user.
    # This is the one object which is stored in session.
    class Container

      def initialize()
        @contexts = {}
      end

      # @return [Base, nil] {Base} with +id+
      # @param [String] id of a {Base}
      def [](id)
        @contexts[id]
      end

      # creates new {Base} with +layout+ and +root_component+
      # @param [] see {Component::Base#initialize}
      def new_context(layout, root_component)
        id = Isy.generate_id
        @contexts[id] = Base.new(id, layout, root_component)
      end

      # context's count
      def size
        @contexts.size
      end

    end
  end
end
