module Isy
  module Components
    class Array < Component

      def initialize(components)
        @components = components
      end

      # TODO delegate to components manipulate methods

      def content
        before

        if @components.blank?
          nothing
        elsif @components.size == 1
          widget @components.first
        else
          widget @components.first
          @components[1..-1].each do |component|
            between
            widget component
          end
        end

        after
      end

      protected

      def before; end
      def after; end
      def between; end
      def nothing; end

    end
  end
end
