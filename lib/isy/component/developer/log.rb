# encoding: UTF-8

module Isy
  module Component
    module Developer
      class Log < Isy::Component::Base

        attr_reader :messages

        def initial_state
          @messages = []
          @limit = 200
          
          @observer = Isy.logger.add_observer(:message) do |message|
            Isy.logger.silence(5) do
              context.schedule do
                Isy.logger.silence(5) do
                  add_message(message)
                  context.actualize.send!
                end
              end
            end
          end

          context.add_observer(:drop) do
            Isy.logger.delete_observer :message, @observer
          end
        end

        private

        def add_message(message)
          @messages.unshift message
          #    @messages = @messages[0...@limit] if @messages.size > @limit
        end

        class Widget < Isy::Widget::Component
          def content
            h3 'Log'

            p "objects observing: #{Isy.logger.count_observers(:message)}"

            component.messages.each do |message|
              p :class => odd do
                text message
              end
            end
          end

          def odd
            (@odd = !@odd) ? 'odd' : 'even'
          end

        end

      end

    end
  end
end
