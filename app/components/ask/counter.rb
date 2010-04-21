module Ask
  class Counter < Counters::Counter

    class Widget < superclass.widget_class

      def content
        super
        p do
          link_to('Add') { answer!(counter) }
          text ' '
          link_to('Cancel') { answer! }
        end

      end
    end

  end
end