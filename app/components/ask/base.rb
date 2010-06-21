module Ask
  class Base < Isy::Components::Component

    # +numbers+ - answered numbers
    # +counter+ is place where is counter stored or form would been
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
        if component.numbers.blank?
          text 'none'
        else
          component.numbers.each_with_index do |number, index|
            text '+' if index > 0
            link_to(number.to_s) do
              @counter = ask Ask::Counter, number do |answer|
                if answer
                  @numbers.delete_at(index)
                  @numbers.insert(index, answer)
                end
                @counter = nil
              end
            end
          end
          #        text component.numbers.join(' + ')
          text " = #{component.sum}"
        end
        br

        # If counter is set, let's show it
        # if not, let's add link to new one
        if component.counter
          widget component.counter
        else
          link_to('Select Number') do
            # if 'Select Number' is clicked, +counter+ is set and
            # ask-callback is set. Both blocks are evaluated inside
            # the same component.
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