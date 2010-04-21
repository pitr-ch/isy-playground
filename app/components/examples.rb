class Examples < Isy::Components::Component

  set_layout_class AppLayout
  attr_reader :example

  def initial_state
    @example = nil
  end

  class Widget < Isy::Widgets::Base
    def content
      strong 'Examples:'
      ul do
        li { link_to("Counters") { @example = Counters::Base.new(self) } }
        li { link_to("#ask") { @example = Ask::Base.new(self) } }
        li { link_to("none") { @example = nil } }
      end
      
      hr

      widget component.example if component.example
    end
  end

end
