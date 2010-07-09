module Isy
  module Component
    module Developer

      class Inspection::Class < Inspection::Module

        def unpack
          super << inspector(obj.superclass, 'superclass:')
        end       
        
      end
    end
  end
end
