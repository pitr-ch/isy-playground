module Isy
  module Widget
    module FormPart
      class Input < Abstract

        needs :type => :text

        def content
          input({ :type => @type, :value => c.value(@value), :'data-value' => @value }.merge(@options))
        end
      end
    end
  end
end