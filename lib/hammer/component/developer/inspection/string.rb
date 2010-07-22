module Hammer
  module Component
    module Developer

      class Inspection::String < Inspection::Object

        def unpack
          @components = []
        end

        class Widget < Inspection::Object::Widget
          def content
            text c.obj.inspect
          end
        end
      end
    end
  end
end
