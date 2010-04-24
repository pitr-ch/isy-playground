module Times
  class UnsavedTimes < Isy::Components::Component


    def unsaved_times
      @unsaved_times ||= []
    end

    def start_new
      @unsaved_times << Work.new(self)
    end

    def widget_args
      unsaved_times
    end

    class Widget < Isy::Widgets::Collection
      def after
        action("Add counter") { add }
      end
    end

    class Widget < Isy::Widgets::Base
      def content
        h2 'Unsaved Times'
        super
      end
    end

  end
end