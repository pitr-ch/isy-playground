module Isy
  module Widget

    # Abstract layout for Isy applications
    class Layout < Erector::Widgets::Page

      external :js, "js/jquery-1.4.2.min.js"
      external :js, "js/isy.js"
      
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
            "isy.setVariables({" + 
            "server: \"#{Config[:websocket][:server]}\"," +
            "port: #{Config[:websocket][:port]}, " +
            "sessionId: \"#{session_id}\"," +
            "sendLogBack: #{Config[:js][:send_log_back]}});"
      end

    end
  end
end