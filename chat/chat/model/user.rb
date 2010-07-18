# encoding: UTF-8

module Chat
  module Model
    class User
      attr_accessor :email, :nick

      def initialize(email = nil, nick = nil)
        @email, @nick = email, nick
      end

      def valid?
        @email.present? && @nick.present?
      end

      def to_s
        @nick
      end
    end
  end
end