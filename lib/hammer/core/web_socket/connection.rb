# encoding: UTF-8

module Hammer
  module Core
    module WebSocket
      class Connection < EventMachine::WebSocket::Connection

        # automatically code Hash messages to JSON and perform logging when active
        def send(hash)
          Hammer.logger.debug "Websocket sending: #{hash}" if Config[:logger][:show_traffic]
          super(JSON[ hash ])
        end

        # automatically decode JSON messages to Hash and perform logging when active
        def onmessage(&block)
          super( &proc do |msg|
              msg = JSON.parse(msg)
              Hammer.logger.debug "Websocket recieved: #{msg}" if Config[:logger][:show_traffic]
              block.call msg
            end)
        end
      end
    end
  end
end
