# encoding: UTF-8

module Isy
  module Core

    # represents context of user, each tab of browser has one of its own
    class Context
      attr_reader :id, :connection, :container, :hash

      # @param [String] id unique identification
      def initialize(id, container, hash = nil)
        @id, @container, @hash = id, container, hash
        @root_component = root_class.new(self)
        @queue, @message = [], {}
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
      def root_class
        @root_class ||= unless @hash == 'devel'
          Config[:root_class].to_s.constantize
        else
          Component::Developer::Tools
        end
      end

      def location_hash
        root_class == Component::Developer::Tools ? 'devel' : ''
      end

      # renders actualization for the user and stores it in {#message}
      def actualize
        Isy.benchmark('Actualization') do
          message :html => self.to_html
        end
        self
      end

      # adds context id to {#message}. It's used after loading layout.
      def send_id(connection)
        self.connection = connection
        message :context_id => self.id
        self
      end

      # sends current message to user through {#connection}
      def send!
        connection.send message
        @message.clear
      end

      # @yield block scheduled into fiber_pool for delayed execution
      def schedule(&block)
        # TODO context queue
        @queue << block
        schedule_next unless @running
        self
      end

      # renders html, similar to Erector::Widget#to_s
      def to_html
        @root_component.to_html
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

      # @return [Hash] current message stored to {#send!}
      # @param [Hash] hash to be merged into current message
      def message(hash = {})
        @message.merge! hash
      end

      # deletes all stored {Action}-s
      def clear_actions
        @actions = {}
      end

      # schedules next block from @queue to be processed in {Base.fibers_pool}
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