module Chat
  class Room < Isy::Component::Base

    attr_reader :room, :user
    def initialize(context, room, user)
      @room, @user = room, user
      super(context)
    end

    def initial_state
      super
      ask_message

      room.add_observer(:message, self, :new_message)
      context.add_observer(:drop, self, :context_dropped)
    end

    def leave!
      room.delete_observer :message, self
      context.delete_observer :drop, self
    end

    def new_message
      context.schedule { context.actualize.send! }
    end

    def context_dropped(context)
      leave!
    end

    attr_reader :message_form
    def ask_message
      @message_form = ask(Chat::MessageForm, Chat::Model::Message.new(user)) { |message|
        room.add_message message
        ask_message
      }
    end

    class Widget < Isy::Widget::Component
      require 'gravatarify'
      include Gravatarify::Helper
      
      def content
        h2 room.name
        render message_form
        room.messages.each {|m| message(m) }
      end

      def message(message)
        div :class => %w[message ui-corner-all] do
          img :src => gravatar_url(message.user.email, :size => 32, :default => :wavatar), :alt => 'avatar'
          span(:class => :time) { text message.time.strftime('%H:%M:%S') }
          strong "#{message.user}: "
          text "#{message.text}"
        end
      end
    end

  end
end