# encoding: UTF-8
module Examples
  class Counter < Hammer::Component::Base

    attr_reader :counter

    def initial_state
      @counter = 0
    end

    class Widget < Hammer::Widget::Component
      def content
        h3 'Counter'
        p do
          text("Value is #{counter} ")
          cb.a('Increase').event(:click).action! { @counter += 1 }
          cb.a('Decrease').event(:click).action! { @counter -= 1 }
          actions
        end
      end

      def actions
      end
    end

  end
end
