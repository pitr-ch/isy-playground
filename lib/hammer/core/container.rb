# encoding: UTF-8

module Hammer
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
      def context(id = nil, hash = nil)
        @contexts[id] || begin
          id = Core.generate_id
          @contexts[id] = Context.new(id, self, hash)
        end
      end

      # restarts context when hash has changed or error occurred
      # @param [String] id of a context
      # @param [String] hash new or current
      # @param [WebSocket::Connection] connection to the client
      # @param [String] warn warning which will be shown to user
      def restart_context(id, hash, connection, warn = nil)
        context = @contexts[id] = Context.new(id, self, hash)
        context.connection=(connection)
        context.schedule(false) { context.actualize.warn(warn).send! }
        context
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
