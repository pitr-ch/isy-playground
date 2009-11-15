module Isy
  module Widgets
    class ComponentInspector < Base

      def content
        widget Inspector.new(component, :pp)
      end

    end
  end
end