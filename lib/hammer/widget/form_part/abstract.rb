module Hammer
  module Widget
    module FormPart
      class Abstract < Widget::Component

        wrap_in(:span)

        needs \
            :value => :value,
            :options => {}

      end
    end
  end
end