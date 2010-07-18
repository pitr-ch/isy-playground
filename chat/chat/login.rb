# encoding: UTF-8

module Chat
  class Login < Isy::Component::FormPart

    def initialize(context, user)
      super(context)
      @record = user
    end

    alias_method(:user, :record)

    class Widget < Isy::Component::FormPart::Widget
      def content
        p do
          h1 "Log in", :class => %w[ui-widget]
          text 'Name:'
          widget Isy::Widget::FormPart::Input, :value => :nick, :options => 
              { :class => %w[ui-widget-content ui-corner-all] }
          text 'Email:'
          widget Isy::Widget::FormPart::Input, :value => :email, :options =>
              { :class => %w[ui-widget-content ui-corner-all] }
          a "Log in", :click => [ actualize_form, do_action { answer!(user) if user.valid? } ]
        end
      end
    end

  end
end