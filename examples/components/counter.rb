# encoding: UTF-8

class Counter < Isy::Component::Base

  attr_reader :counter

  def initial_state
    @counter = 0
  end

  class Widget < Isy::Widget::Component
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
