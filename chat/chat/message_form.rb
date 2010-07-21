module Chat
  class MessageForm < Isy::Component::FormPart

    def initialize(context, message)
      super(context)
      @record = message
    end

    alias_method(:message, :record)

    class Widget < Isy::Component::FormPart::Widget
      def content
        cb.a("Send").event(:click).form.action! {
            if message.valid?
              message.time!
              answer!(message)
            end
          }
        widget Isy::Widget::FormPart::Textarea, :value => :text, :options =>
            { :rows => 2, :class => %w[ui-widget-content ui-corner-all] }
        
      end
    end

  end
end