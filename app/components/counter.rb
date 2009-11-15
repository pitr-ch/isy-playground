class Counter < Isy::Components::Component

  attr_reader :counter

  def initial_state
    @counter = 0
  end

  class Widget < Isy::Widgets::Base
    def content
      h3 'Counter'
      p do
        text("Value is #{component.counter}")
      end
    end
  end

  self.widget_class = Widget

end