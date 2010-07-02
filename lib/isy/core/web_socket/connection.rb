module Isy
  module Core
    module WebSocket
      class Connection < EventMachine::WebSocket::Connection
        def send(hash)
          Isy.logger.debug "Websocket sending: #{hash}" if Config[:logger][:show_traffic]
          data = JSON[ Hash[ *hash.stringify_keys.map {|k,v| [k.camelize(:lower), v]}.flatten(1) ]]          
          super(data)
        end

        def onmessage(&block)
          super( &proc do |msg|
              msg = Hash[ *JSON.parse(msg).map {|k, v| [k.underscore.to_sym, v] }.flatten(1) ]
              Isy.logger.debug "Websocket recieved: #{msg}" if Config[:logger][:show_traffic]
              block.call msg
            end)
        end
      end
    end
  end
end
