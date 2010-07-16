# encoding: UTF-8
module Examples
  module Ask
    class Counter < Examples::Counter

      def initialize(context, number = 0)
        super(context)
        @counter = number
      end

      class Widget < superclass.widget_class

        # adds links to answer the number (counter) or
        # to answer nothing.
        # Everything else is as we need.
        def actions
          a 'Add number', :click => do_action { answer!(counter) }
          a 'Cancel', :click => do_action { answer! }
        end
      end
    end

  end
end
