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
              li { cb.a("Log").event(:click).action! { @tool = new Isy::Component::Developer::Log } }
              li { cb.a("Inspector Isy::Core::Base").event(:click).action! { @tool = inspector Isy::Core::Base } }
              li { cb.a("Inspector Object").event(:click).action! { @tool = inspector Object } }
              li { cb.a("Inspector Isy.logger").event(:click).action! { @tool = inspector Isy.logger } }
              if defined? Chat::Model::Room
                li { cb.a("Inspector Chat::Model::Room").event(:click).action! { @tool = inspector Chat::Model::Room } }
              end
              li { cb.a("GC and stats").event(:click).action! { @tool = new Developer::Gc } }
              if defined? Memprof
                li { cb.a("Memprof dump all").event(:click).action! { Memprof.dump_all("heap_dump.json") }}
              end
              li { cb.a("none").event(:click).action! { @tool = nil } }
            end
      
            hr

            render component.tool if component.tool
          end
        end

      end
    end
  end
end
