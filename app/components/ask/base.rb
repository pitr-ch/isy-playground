module Ask
  class Base < Isy::Components::Component

    attr_reader :numbers, :counter

    def initial_state
      @numbers = []
      @counter = nil
    end

    def sum
      numbers.inject {|sum, num| sum + num }
    end

    class Widget < Isy::Widgets::Base

      def content
        strong 'Numbers:'
        text component.numbers.join(' + ')
        text " = #{component.sum}"

        br

        if component.counter
          widget component.counter
        else
          link_to('Select Number') do
            @counter = ask Ask::Counter do |answer|
              if answer
                @numbers << answer
              end
              @counter = nil
            end
          end
        end
      end
    end

  end
end