class Layout < Erector::Widgets::Page

  attr_reader :session, :login_filter
  attr_accessor :session

  def initialize(assigns = {}, &block)
    super(assigns, &block)
    @login_filter = LoginFilter.new
  end

  def page_title
    "Akce"
  end

  def body_content
    h1 "My App"
    p "welcome to my app"
    widget login_filter
  end


end