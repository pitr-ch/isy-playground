module Isy
  module Core

    # represents context of user, each tab of browser has one of its own
    class Context
      attr_reader :id, :connection, :container

      # @param [String] id unique identification
      def initialize(id, container)
        @id, @container = id, container
        @root_component = self.class.root_class.new(self)
        @queue = []
        clear_actions
      end

      # store connection to be able to send server-side actualizations
      # @param [WebSocket::Connection] connection
      def connection=(connection)
        @connection = connection
        self.class.by_connection_hash[connection] = self
      end

      # remove context form container
      def drop
        container.drop_context(self)
      end

      # @return [Class] class of a root component
      def self.root_class
        @root_class ||= Config[:root_class].to_s.constantize
      end

      # pushes actualization to the user
      def actualize!
        Isy.benchmark('Actualization') { connection.send :command => REPLACE_BODY, :html => self.to_s }
        self
      end

      # sends context id. It's used after loading layout.
      def send_id!(connection)
        self.connection = connection
        connection.send :command => SET_CONTEXT, :context_id => self.id
        self
      end

      # @yield block scheduled into fiber_pool for delayed execution
      def schedule(&block)
        # TODO context queue
        @queue << block
        schedule_next unless @running
        self
      end

      # renders html, similar to Erector::Widget#to_s
      def to_s
        @root_component.to_s
      end

      # creates and stores action for later evaluation
      # @param [Component::Base] component where action will be evaluated
      # @yield the action
      def register_action(component, &block)
        uuid = Core.generate_id
        @actions[uuid] = Action.new(uuid, component, block)
        return uuid
      end

      # evaluates action with +id+
      # @param [String] id of a {Action}
      def run_action(id)
        #        time = Benchmark.realtime do
        (action = @actions[id]) && action.call
        clear_actions
        #        end
        #        Isy.logger.info 'Action in %0.6f sec' % time
        self
      end

      # @param [WebSocket::Connection] connection to find out by
      # @return [Context] by +connection+
      def self.by_connection(connection)
        by_connection_hash[connection]
      end

      private

      # deletes all stored {Action}-s
      def clear_actions
        @actions = {}
      end

      def schedule_next
        if block = @queue.shift
          @running = block
          Base.fibers_pool.spawn { Base.safely { block.call; schedule_next } }
        else
          @running = nil
        end
      end

      def self.by_connection_hash
        @connection_hash ||= {}
      end

    end
  end
end