module Isy
  module Component
    module Developer

      class Inspection::Hash < Inspection::Object

        def unpack
          @components = obj.to_a.flatten(1).map do |value|
            inspector value
          end
        end

      end
    end
  end
end
