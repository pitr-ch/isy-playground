class Testicek < Isy::Components::Component

  set_layout_class AppLayout
  set_widget_class Isy::Widgets::Collection

  def initial_state
    Counter.new(self)
    Counter.new(self)
  end

  def widget_args
    super << children
  end

end