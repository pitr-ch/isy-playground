module Isy
  module Widget

    # Abstract layout for Isy applications
    class Layout < Erector::Widgets::Page

      external :js, 'js/jquery-1.4.2.js'
      external :js, 'js/jquery.ba-hashchange.js'
      #      external :js, 'js/swfobject.js'
      #      external :js, 'js/FABridge.js'
      #      external :js, 'js/web_socket.js'
      external :js, 'js/isy.js'

      external :css, 'developer.css'
      
      def body_content
        loading
      end

      def head_content
        super
        set_variables(@session_id)
      end

      def loading
        h1 'Loading ...'
      end

      private

      def set_variables(session_id)
        javascript \
            "isy._setVariables({" +
            "server: \"#{Config[:websocket][:server]}\"," +
            "port: #{Config[:websocket][:port]}, " +
            "sessionId: \"#{session_id}\"," +
            "sendLogBack: #{Config[:js][:send_log_back]}});" #+
        #            "window.WEB_SOCKET_SWF_LOCATION = \"js/WebSocketMain.swf\""
      end

    end
  end
end