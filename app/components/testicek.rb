class Testicek < Isy::Components::Component

  def initialize(parent, context)
    super
    new_component(Counter)
    new_component(Counter)
  end

end