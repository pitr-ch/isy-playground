class AppLayout < Erector::Layout

  def page_title
    "Akce"
  end

  def body_content
    h1 "My App"
    p "welcome to my app"
    super
  end


end