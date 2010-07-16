# encoding: UTF-8

module Isy
  module Component
    module Developer
      class Log < Isy::Component::Base

        attr_reader :messages

        def initial_state
          @messages = []
          @limit = 200

          # observe log :message event
          @observer = Isy.logger.add_observer(:message) do |message|
            Isy.logger.silence(5) do # we don't want to end up in infinite loop
              context.schedule do
                Isy.logger.silence(5) do
                  add_message(message)
                  context.actualize.send!
                end
              end
            end
          end

          # listen context for :drop event then delete observer to collect by GC
          context.add_observer(:drop) do
            Isy.logger.delete_observer :message, @observer
          end
        end

        private

        def add_message(message)
          @messages.unshift message
          @messages.pop if @messages.size > @limit
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
