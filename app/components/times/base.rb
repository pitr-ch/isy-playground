module Times
  class Base < Isy::Components::Component

    set_layout_class TimesLayout

    attr_reader :unsaved

    def initial_state
      @unsaved = UnsavedTimes.new(self)
#      @saved = SavedTimes.new
    end

#    def add
#      @counters << Counter.new(self)
#    end
#
#    def widget_args
#      super << children
#    end

    class Widget < Isy::Widgets::Base
      def content
        widget component.unsaved
      end
    end

  end
end