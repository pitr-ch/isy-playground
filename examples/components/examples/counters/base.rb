# encoding: UTF-8
module Examples
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
          a "Add counter", :click => do_action { add }
        end
      end

    end
  end
end
