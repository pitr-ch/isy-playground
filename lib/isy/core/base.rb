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
        @containers.delete(container.id)
      end

      # runs websocket server - schedule start after eventmachine startup in thin
      def self.run!
        run_websocket_server
      end

      # @return [Hash] configuration for :websocket
      def self.config
        Config[:websocket]
      end

      @fibers_pool = NeverBlock::Pool::FiberPool.new

      # @return [NeverBlock::Pool::FiberPool]
      def self.fibers_pool
        @fibers_pool
      end

      # tries to execute block safely, errors are logged
      # @yield block to safe execution
      def self.safely(&block)
        begin
          block.call
        rescue Exception => e
          Isy.logger.exception e
        end
      end

      private

      # setups websocket server
      def self.run_websocket_server
        EM.epoll
        EM.schedule do
          EventMachine::start_server config[:host], config[:port], WebSocket::Connection,
              :debug => config[:debug] do |connection|

            connection.onopen do
              Isy.logger.debug "WebSocket connection opened"
            end

            connection.onmessage do |message|
              if !(session_id = message['session_id'])
                Isy.logger.warn "missing session_id"
              elsif !(context_id = message['context_id'])
                context = Base.container(session_id).context(nil, message['hash'])
                context.schedule { context.send_id(connection).actualize.send! }
              elsif (action_id = message['action_id'])
                context = Base.container(session_id).context(context_id)
                context.schedule { context.run_action(action_id).actualize.send! }
              elsif context_id
                Base.container(session_id).context(context_id).drop
                context = Base.container(session_id).context(nil, message['hash'])
                context.schedule { context.send_id(connection).actualize.send! }
              else
                Isy.logger.warn "Non valid message: #{message}"
              end
            end

            connection.onclose do
              Isy.logger.debug "WebSocket connection closed"
              safely do
                Context.by_connection(connection).drop
              end
            end
          end
          
          Isy.logger.info '== Isy WebSocket running.'
        end
      end

    end
  end
end