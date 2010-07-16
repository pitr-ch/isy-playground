module Isy
  module Widget
    module FormPart
      class Abstract < Widget::Component

        needs \
            :value => :value,
            :options => {}

      end
    end
  end
end