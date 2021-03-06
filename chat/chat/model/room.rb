module Chat
  module Model
    class Room
      include Hammer::Core::Observable
      observable_events :message
    
      attr_reader  :messages
      attr_accessor :name
      def initialize(name = nil)
        @name = name
        @messages = []
      end

      def valid?
        @name.present?
      end

      def add_message(message)
        @messages.unshift message
        @messages.pop if @messages.size > 50
        notify_observers(:message)
      end

      def last_update
        @messages.first.try(:time) || Time.now
      end

      @rooms = []
      
      def self.rooms
        @rooms
      end

      EM.schedule do
        EventMachine::add_periodic_timer 5 do
          rooms.delete_if {|room| Time.now - room.last_update > 60*60 }
        end
      end

    end
  end
end
