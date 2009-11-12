module Isy
  class Layout < Erector::Widgets::Page

    def initialize(root_component, assigns = {}, &block)
      super(assigns, &block)
      @root_component = root_component
    end

    def body_content
      widget @root_component
    end

  end
end