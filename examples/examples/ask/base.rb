# encoding: UTF-8
module Examples
  module Ask
    class Base < Isy::Component::Base

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

      class Widget < Isy::Widget::Component

        def content
          strong 'Numbers:'
          if numbers.blank?
            text 'none'
          else
            numbers.each_with_index do |number, index|
              text '+' if index > 0
              cb.a(number.to_s).event(:click).action! {
                @counter = ask Examples::Ask::Counter, number do |answer|
                  if answer
                    @numbers.delete_at(index)
                    @numbers.insert(index, answer)
                  end
                  @counter = nil
                end
              }
            end
            #        text component.numbers.join(' + ')
            text " = #{sum}"
          end
          br

          # If counter is set, let's show it
          # if not, let's add link to new one
          if counter
            render counter
          else
            cb.a('Select Number').event(:click).action! {
              # if 'Select Number' is clicked, +counter+ is set and
              # ask-callback is set. Both blocks are evaluated inside
              # the same component.
              @counter = ask Examples::Ask::Counter do |answer|
                if answer
                  @numbers << answer
                end
                @counter = nil
              end
            }
          end
        end
      end

    end
  end
end
