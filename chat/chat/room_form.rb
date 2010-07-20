module Chat
  class RoomForm < Isy::Component::FormPart

    def initialize(context, room)
      super(context)
      @record = room
    end

    alias_method(:room, :record)

    class Widget < Isy::Component::FormPart::Widget
      wrap_in(:span)
      def content
        widget Isy::Widget::FormPart::Input, :value => :name, :options =>
            { :class => %w[ui-widget-content ui-corner-all] }
        a "Add", :click => [ actualize_form, do_action {
            if room.valid?
              answer!(room)
            end
          }]
        a "Cansel", :click => [ do_action { answer!(nil) }]
      end
    end

  end
end