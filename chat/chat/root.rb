# encoding: UTF-8

module Chat
  class Root < Hammer::Component::Base

    attr_reader :user
    def initial_state
      super
      unless @user
        pass_on ask(Login, Model::User.new) { |user|
          @user = user
          File.open('users.log', 'a') { |f| f.write "#{@user.nick}\t#{@user.email}\n"  }
          pass_on new(Chat::Rooms, @user)
        }
      end
    end

    class Widget < Hammer::Widget::Component
      def content
        text user.inspect
      end
    end

  end
end