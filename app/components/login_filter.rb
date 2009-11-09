class LoginFilter < Erector::Component

  def initialize(assigns = {}, &block)
    @counter = 1
    @counter += 1
  end

  def content
    p text @counter

    p a(lambda {@counter +=1}, '+counter')
    p a(lambda {@counter -=1}, '-counter')

#    h2 'Session'
#    p do
#      code do
#        text session.inspect
#      end
#    end
  end

  protected
end