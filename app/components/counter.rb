class Counter < Isy::Components::Component

  attr_reader :counter

  def initial_state
    @counter = 0
  end

  def plus
    @counter += 1
  end

  def minus
    @counter -= 1
  end

  class Widget < Isy::Widgets::Base
    def content
      h3 'Counter'
      p do
        text("Value is #{component.counter} ")
        action 'Plus' do plus end
        text ' '
        action 'Minus' do minus end
      end
    end
  end

end