# encoding: UTF-8

module Chat
  class Login < Hammer::Component::FormPart

    def initialize(context, user)
      super(context)
      @record = user
    end

    alias_method(:user, :record)

    class Widget < Hammer::Component::FormPart::Widget
      def content
        p do
          h1 "Log in", :class => %w[ui-widget]
          text 'Name:'
          widget Hammer::Widget::FormPart::Input, :value => :nick, :options => 
              { :class => %w[ui-widget-content ui-corner-all] }
          text 'Email:'
          widget Hammer::Widget::FormPart::Input, :value => :email, :options =>
              { :class => %w[ui-widget-content ui-corner-all] }
          cb.a("Log in").event(:click).form.action! { answer!(user) if user.valid? }
        end
      end
    end

  end
end