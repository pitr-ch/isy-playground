module Chat
  class Rooms < Isy::Component::Base

    attr_reader :room, :user
    attr_accessor :room_form
    
    def initialize(context, user)
      super(context)
      @user = user
    end

    class Widget < Isy::Widget::Component
      def content
#        text Model::Room.rooms.map {|r| r.inspect }

        h1 "Chat rooms"

        Model::Room.rooms.each do |r|
          a "#{r.name} (#{r.messages.size})", :click => do_action { @room.try :leave!; @room = new Room, r, user }
        end
        unless room_form
          a 'new room', :click => do_action() {
            @room_form = ask RoomForm, Model::Room.new do |room|
              Model::Room.rooms << room if room
              @room_form = nil
            end
          }
        else
          render room_form
        end

        render room if room
      end
    end

  end
end