module Ask
  class Counter < ::Counter

    class Widget < superclass.widget_class

      def actions
        link_to('Add number') { answer!(counter) }
        link_to('Cancel') { answer! }
      end
    end

  end
end