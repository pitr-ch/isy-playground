# encoding: UTF-8

module Hammer

  module Component
    class ComponentException < StandardError; end
    class MissingWidgetClass < ComponentException; end
  end

end