module Hammer
  module Component
    module Developer

      class Inspection::Array < Inspection::Object

        def unpack
          @components = obj.each_with_index.map do |value, i|
            inspector value, "#{i}: "
          end
        end

      end
    end
  end
end
