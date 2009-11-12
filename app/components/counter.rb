class Counter < Isy::Components::Component

  def initialize(assigns = {}, &block)
    @counter = 0
  end

  def content
    h3 'Counter'

    p do
      text "count is: #{@counter} "
      a(lambda {@counter +=1}, '+')
      text ","
      a(lambda {@counter -=1}, '-')
    end
  end

end