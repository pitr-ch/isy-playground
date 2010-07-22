module Hammer
  module Widget
    module FormPart
      class Textarea < Abstract

        def content
          textarea(value(@value), { :type => @type, :'data-value' => @value }.merge(@options))
        end
      end
    end
  end
end