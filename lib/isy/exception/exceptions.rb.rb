module Isy

  module Component
    class ComponentException < StandardError; end
    class MissingWidgetClass < ComponentException; end
  end

end