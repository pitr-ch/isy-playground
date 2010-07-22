module Chat
  class RoomForm < Hammer::Component::FormPart

    def initialize(context, room)
      super(context)
      @record = room
    end

    alias_method(:room, :record)

    class Widget < Hammer::Component::FormPart::Widget
      wrap_in(:span)
      def content
        widget Hammer::Widget::FormPart::Input, :value => :name, :options =>
            { :class => %w[ui-widget-content ui-corner-all] }
        cb.a("Add").event(:click).form.action! {
            if room.valid?
              answer!(room)
            end
          }
        cb.a("Cansel").event(:click).action! { answer!(nil) }
      end
    end

  end
end