module Counters
  class Base < Isy::Components::Component

    attr_reader :counters

    def initial_state
      @counters = [ Counter.new(self) ]
    end

    def add
      @counters << Counter.new(self)
    end

    def widget_args
      super << children
    end

    class Widget < Isy::Widgets::Collection
      def after
        link_to("Add counter") { add }
      end
    end

  end
end