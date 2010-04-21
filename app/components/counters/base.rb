module Counters
  class Base < Isy::Components::Component

    attr_reader :counters

    def initial_state
      @counters = [ new(Counter, self) ]
    end

    def add
      @counters << new(Counter, self)
    end

    def remove(counter)
      @counters.delete(counter)
    end

    def widget_args
      super << counters
    end

    class Widget < Isy::Widgets::Collection
      def after
        link_to("Add counter") { add }
      end
    end

  end
end