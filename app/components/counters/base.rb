module Counters
  class Base < Isy::Component::Base

    attr_reader :counters
    alias_method :collection, :counters

    # defines the state after new instance is created
    def initial_state
      @counters = [ new(Counter, self) ]
    end

    # adds new counter
    def add
      counters << new(Counter, self)
    end

    # removes a +counter+
    def remove(counter)
      counters.delete(counter)
    end

    class Widget < Isy::Widget::Collection
      def after
        link_to("Add counter") { add }
      end
    end

  end
end