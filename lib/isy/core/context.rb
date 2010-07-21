# encoding: UTF-8

module Isy
  module Core

    # represents context of user, each tab of browser has one of its own
    class Context
      include Core::Observable
      observable_events :drop

      attr_reader :id, :connection, :container, :hash

      # @param [String] id unique identification
      def initialize(id, container, hash = '')
        @id, @container, @hash = id, container, hash
        @root_component = root_class.new(self)
        @queue, @message = [], {}
        self.class.no_connection_contexts << self
        clear_actions
      end

      # store connection to be able to send server-side actualizations
      # @param [WebSocket::Connection] connection
      def connection=(connection)
        @connection = connection
        self.class.contexts_by_connection[connection] = self
        self.class.no_connection_contexts.delete self
      end

      # remove context form container
      def drop        
        self.class.contexts_by_connection.delete(connection)
        self.class.no_connection_contexts.delete(self)
        container.drop_context(self)
        notify_observers(:drop, self)
      end

      # @return [Class] class of a root component
      def root_class
        @root_class ||= unless @hash == Config[:core][:devel]
          Config[:root_class].to_s.constantize
        else
          Component::Developer::Tools
        end
      end

      def location_hash
        root_class == Component::Developer::Tools ? Config[:core][:devel] : ''
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
        connection.send message if connection # FIXME unsended will be lost
        @message.clear
      end

      # @yield block scheduled into fiber_pool for delayed execution
      # @param [Boolean] restart try to restart when error?
      def schedule(restart = true, &block)
        # TODO context queue
        @queue << block
        schedule_next(restart) unless @running
        self
      end

      # renders html, similar to Erector::Widget#to_html
      def to_html
        @root_component.to_html
      end

      # creates and stores action for later evaluation
      # @param [Component::Base] component where action will be evaluated
      # @yield the action
      # @return [String] uuid of the action
      def register_action(component, &block)
        uuid = Core.generate_id
        @actions[uuid] = Action.new(uuid, component, block)
        return uuid
      end

      # evaluates action with +id+
      # @param [String] id of a {Action}
      # @return self
      def run_action(id)
        (action = @actions[id]) && action.call
        clear_actions
        self
      end

      # @param [WebSocket::Connection] connection to find out by
      # @return [Context] by +connection+
      def self.by_connection(connection)
        contexts_by_connection[connection]
      end

      # processes safely block, restarts context when error occurred
      # @yield task to execute
      # @param [Boolean] restart try to restart when error?
      def safely(restart = true, &block)
        unless Base.safely(&block)
          if restart
            container.restart_context id, hash, connection,
                "We are sorry but there was a error. Application is reloaded"
          else
            warn("Fatal error").send!
          end
        end
      end

      # @param [String] warn which will be shown to user using alert();
      # @return self
      def warn(warn)
        message :js => "alert('#{warn}');" if warn
        self
      end

      # updates values in form parts
      # @param [Hash] hash ['form'] part of message form client
      # @return self
      def update_form(hash)
        Isy.benchmark "Updating form" do
          return self unless hash && hash.kind_of?(Hash)
          hash.each do |id, values|
            form_part = begin ObjectSpace._id2ref(id.to_i) rescue RangeError end
            # FIXME dangerous
            if form_part
              values.each {|key, value| 
                form_part.set_value(key, value)
              }
            else
              Isy.logger.debug "missing form with id: #{id.to_i} for values: #{values.inspect}"
            end
          end
        end
        self
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
      # @param [Boolean] restart try to restart when error?
      def schedule_next(restart = true)
        if block = @queue.shift
          @running = block
          Base.fibers_pool.spawn { safely(restart) { block.call; schedule_next } }
        else
          @running = nil
        end
      end

      @contexts_by_connection = {}
      def self.contexts_by_connection
        @contexts_by_connection
      end

      @no_connection_contexts = []
      def self.no_connection_contexts
        @no_connection_contexts
      end

    end
  end
end