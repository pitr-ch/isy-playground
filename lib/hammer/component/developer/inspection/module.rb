module Hammer
  module Component
    module Developer

      class Inspection::Module < Inspection::Object
        def unpack
          super << inspector(
            obj.constants.inject({}) {|hash, name| hash[name] = obj.const_get(name); hash },
            'Constants') <<
              inspector(obj.included_modules, 'Included Modules')
        end

        class Widget < Inspection::Object::Widget
          def name
            c.obj.to_s
          end
        end

      end
    end
  end
end
