module Isy
  module Component
    module Developer
      class Tools < Isy::Component::Base
    
        attr_reader :tool

        def initial_state
          @tool = nil
        end

        class Widget < Isy::Widget::Component
          def content
            strong 'Tools:'
            ul do
              li { link_to("Log") { @tool = new Log } }
              li { link_to("none") { @tool = nil } }
            end
      
            hr

            render component.tool if component.tool
          end
        end

      end
    end
  end
end
