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
          a 'Increase', :click => do_action { @counter += 1 }
          a 'Decrease', :click => do_action { @counter -= 1 }
          actions
        end
      end

      def actions
      end
    end

  end
end
