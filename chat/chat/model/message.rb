module Chat
  module Model
    class Message

      attr_reader :user, :time
      attr_accessor :text
      def initialize(user, text = nil)
        @user, @text = user, text
      end

      def valid?
        @text.present?
      end

      def time!
        @time = Time.now
      end

    end

  end
end