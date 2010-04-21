class Counters::Counter < Isy::Components::Component

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
        link_to('Plus') { plus }
        text ' '
        link_to('Minus') { minus }
        text ' '
        link_to('Remove') { remove }
      end
    end
  end

end