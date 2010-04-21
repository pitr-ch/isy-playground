class Counter < Isy::Components::Component

  attr_reader :counter

  def initial_state
    @counter = 0
  end

  class Widget < Isy::Widgets::Base
    def content
      h3 'Counter'
      p do
        text("Value is #{component.counter} ")
        link_to('Increase') { @counter += 1 }
        link_to('Decrease') { @counter -= 1 }
        actions
      end
    end

    def actions
    end
  end

end
