class Testicek < Isy::Components::Component

  self.layout_class = AppLayout

  def initial_state
    new_component(Counter)
    new_component(Counter)
  end

  self.widget_class = Isy::Widgets::Collection
  
  def widget_args
    super << children
  end

end