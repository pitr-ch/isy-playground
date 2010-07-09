# encoding: UTF-8

module Isy
  module Component
    module Developer
      class Tools < Isy::Component::Base
    
        attr_reader :tool

        def initial_state
          @tool = nil
        end

        class TT
          def initialize
            @as = rand
            @af = rand.to_s
          end
        end

        class Widget < Isy::Widget::Component
          def content
            strong 'Tools:'
            ul do
              li { link_to("Log") { @tool = new Isy::Component::Developer::Log } }
              li { link_to("Inspector Isy::Core::Base") { @tool = inspector Isy::Core::Base } }
              li { link_to("Inspector Object") { @tool = inspector Object } }
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
