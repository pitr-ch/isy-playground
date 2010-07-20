# encoding: UTF-8

class AppLayout < Isy::Widget::Layout

  external :css, "css/chat.css"
  external :css, "css/basic.css"
  external :css, "css/ui-lightness/jquery-ui-1.8.2.custom.css"
  external :js, "js/jquery-ui-1.8.2.custom.min.js"
  external :js, "js/chat.js"

  def page_title
    "ISY - Chat"
  end

end