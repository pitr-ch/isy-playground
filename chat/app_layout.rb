# encoding: UTF-8

class AppLayout < Hammer::Widget::Layout

  external :css, "css/ui-lightness/jquery-ui-1.8.2.custom.css"
  external :css, "css/basic.css"
  external :css, "css/chat.css"
  external :js, "js/jquery-ui-1.8.2.custom.min.js"
  external :js, "js/chat.js"

  def page_title
    "Hammer - Chat"
  end

end