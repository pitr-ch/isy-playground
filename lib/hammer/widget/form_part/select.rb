module Hammer
  module Widget
    module FormPart
      class Select < Abstract

        needs :select_options

        def content
          select({ :value => value(@value), :'data-value' => @value }.merge(@options)) { options_for_select }
        end

        private

        def options_for_select
          @select_options.each do |opt|
            value, text = opt
            text ||= value
            option text, :value => value, :selected => value(@value) == value ? :selected : false
          end
        end

      end
    end
  end
end