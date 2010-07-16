# encoding: UTF-8

module Isy
  module Component
    module Developer
      class Gc < Isy::Component::Base

        class Widget < Isy::Widget::Component
          def content
            stats
            gc
          end

          def stats
            h1 'Stats'
            ul do
              [ Isy::Core::Container,
                Isy::Core::Context,
                Isy::Component::Base,
                Isy::Widget::Base
              ].each do |klass|
                li "#{klass}: #{ObjectSpace.each_object(klass) {}}"
              end
            end
          end

          def gc
            h1 'GC'
            ul do
              li do                
                a "GC::Profiler.enable? => #{GC::Profiler.enabled?}", :click => do_action {
                  if GC::Profiler.enabled?
                    GC::Profiler.disable
                    GC::Profiler.clear
                  else
                    GC::Profiler.enable
                  end
                }
              end if Isy.v19?
              li { a "GC.start", :click => do_action { ObjectSpace.garbage_collect; ObjectSpace.garbage_collect }}
            end

            pre { code GC::Profiler.result } if Isy.v19?
            pre { code ObjectSpace.count_objects.to_s } if Isy.v19?
          end
        end


      end
    end
  end
end
