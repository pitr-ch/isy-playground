module Hammer
  module Widget
    module FormPart
      class Input < Abstract

        needs :type => :text

        def content
          input({ :type => @type, :value => value(@value), :'data-value' => @value }.merge(@options))
        end
      end
    end
  end
end