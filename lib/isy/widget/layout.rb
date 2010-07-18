# encoding: UTF-8

module Isy
  module Widget

    # Abstract layout for Isy applications
    class Layout < Erector::Widgets::Page

      #      depends_on :js, 'js/swfobject.js', 'js/FABridge.js', 'js/web_socket.js'
      external :js, 'js/jquery-1.4.2.js'
      external :js, 'js/jquery.ba-hashchange.js'
      external :js, 'js/isy.js'
      external :css,  'css/developer.css'
      
      def body_content
        loading
        set_variables(@session_id)
      end

      def head_content
        super
      end

      def loading
        div(:class => 'loading') { img :src => 'img/loading.gif', :alt => "Loading..." }
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