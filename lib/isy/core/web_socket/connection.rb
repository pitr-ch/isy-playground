module Isy
  module Core
    module WebSocket
      class Connection < EventMachine::WebSocket::Connection
        def send(hash)
          Isy.logger.debug "Websocket sending: #{hash}" if Config[:logger][:show_traffic]          
          super(JSON[ hash ])
        end

        def onmessage(&block)
          super( &proc do |msg|
              msg = JSON.parse(msg)
              Isy.logger.debug "Websocket recieved: #{msg}" if Config[:logger][:show_traffic]
              block.call msg
            end)
        end
      end
    end
  end
end
