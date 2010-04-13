class TestApp < Isy::Components::Component

  set_layout_class AppLayout

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
      action("Add counter") { add }
    end
  end

end