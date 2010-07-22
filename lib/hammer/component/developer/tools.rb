# encoding: UTF-8

module Hammer
  module Component
    module Developer
      class Tools < Hammer::Component::Base
    
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

        class Widget < Hammer::Widget::Component
          def content
            strong 'Tools:'
            ul do
              li { cb.a("Log").event(:click).action! { @tool = new Hammer::Component::Developer::Log } }
              li { cb.a("Inspector Hammer::Core::Base").event(:click).action! { @tool = inspector Hammer::Core::Base } }
              li { cb.a("Inspector Object").event(:click).action! { @tool = inspector Object } }
              li { cb.a("Inspector Hammer.logger").event(:click).action! { @tool = inspector Hammer.logger } }
              li do
                cb.a("Inspector Chat::Model::Room.rooms").event(:click).
                    action! { @tool = inspector Chat::Model::Room.rooms }
              end if defined? Chat::Model::Room
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
