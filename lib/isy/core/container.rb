module Isy
  module Core

    # Manages all context of one user.
    # This is the one object which is stored in session.
    class Container

      attr_reader :id
      def initialize(id)
        @id, @contexts = id, {}
      end

      # @return [Base, nil] {Base} with +id+
      # @param [String] id of a {Base}
      def context(id = nil)
        @contexts[id] || begin
          id = Core.generate_id
          @contexts[id] = Context.new(id, self)
        end
      end

      # @param [Context] context to drop when is not needed
      def drop_context(context)
        @contexts.delete(context.id)
        drop if @contexts.empty?
      end

      # drops container when is not needed
      def drop
        Base.drop_container(self)
      end
      
      # context's count
      def size
        @contexts.size
      end

    end
  end
end
