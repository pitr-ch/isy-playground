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
              li { a "Log", :click => do_action { @tool = new Isy::Component::Developer::Log } }
              li { a "Inspector Isy::Core::Base", :click => do_action { @tool = inspector Isy::Core::Base } }
              li { a "Inspector Object", :click => do_action { @tool = inspector Object } }
              li { a "Inspector Isy.logger", :click => do_action { @tool = inspector Isy.logger } }
              li { a "GC and stats", :click => do_action { @tool = new Developer::Gc } }
              li { a "Memprof dump all", :click => do_action { Memprof.dump_all("heap_dump.json") }} if defined? Memprof
              li { a "none", :click => do_action { @tool = nil } }
            end
      
            hr

            render component.tool if component.tool
          end
        end

      end
    end
  end
end
