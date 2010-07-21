# encoding: UTF-8
module Examples
  class Counter < Isy::Component::Base

    attr_reader :counter

    def initial_state
      @counter = 0
    end

    class Widget < Isy::Widget::Component
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
