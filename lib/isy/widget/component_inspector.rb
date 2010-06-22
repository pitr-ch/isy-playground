module Isy
  module Widget
    class ComponentInspector < Base

      def content
        widget Inspector.new(component, :pp)
      end

    end
  end
end