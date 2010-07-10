# encoding: UTF-8

require 'singleton'

module Isy
  module Core

    def self.generate_id
      UUID.generate(:compact).to_i(16).to_s(36)
    end

    class Base
      
      @containers = {}

      # @return [Container] container by user_id (session id is used)
      def self.container(user_id)
        @containers[user_id] ||= Container.new(user_id)
      end

      # delete container where isn't needed any more
      def self.drop_container(container)
        @containers.delete(container.id) || raise
      end

      # runs websocket server - schedule start after eventmachine startup in thin
      def self.run!
        run_websocket_server
      end

      # @return [Hash] configuration for :websocket
      def self.config
        Config[:websocket]
      end

      @fibers_pool = NeverBlock::Pool::FiberPool.new config[:fibers]

      # @return [NeverBlock::Pool::FiberPool]
      def self.fibers_pool
        @fibers_pool
      end

      # tries to execute block safely, errors are logged
      # @yield block to safe execution
      # @return [Boolean] if block was successfully processed
      def self.safely(&block)
        begin
          block.call
        rescue => e
          Isy.logger.exception e
          return false
        end
        return true
      end

      private

      # schedules tasks depending on what message was received
      # @param [String] message which was received
      def self.receive_message(message, connection)
        if !(session_id = message['session_id'])
          Isy.logger.warn "missing session_id"
        elsif !(context_id = message['context_id'])
          context = Base.container(session_id).context(nil, message['hash'])
          context.schedule { context.send_id(connection).actualize.send! }
        elsif (action_id = message['action_id'])
          context = Base.container(session_id).context(context_id)
          context.schedule { context.run_action(action_id).actualize.send! }
        elsif context_id
          context = Base.container(session_id).restart_context(context_id, message['hash'], connection)
        else
          Isy.logger.warn "Non valid message: #{message}"
        end
      end

      # setups websocket server
      def self.run_websocket_server
        EM.epoll
        EM.schedule do
          EventMachine::start_server config[:host], config[:port], WebSocket::Connection,
              :debug => config[:debug] do |connection|

            connection.onopen    { Isy.logger.debug "WebSocket connection opened" }
            connection.onmessage { |message| receive_message(message, connection) }
            connection.onclose do
              safely do
                Isy.logger.debug "WebSocket connection closed"
                Context.by_connection(connection).try :drop
              end
            end
          end
          
          Isy.logger.info '== Isy WebSocket running.'

          EventMachine::add_periodic_timer(10) do
            safely do
              # drops contexts without connections
              contexts = Context.send(:no_connection_contexts)
              unless contexts.empty?
                Isy.logger.debug "Dropping #{contexts.size} context without connection"
                contexts.each {|c| c.drop }
              end
            end
          end
        end
      end

    end
  end
end