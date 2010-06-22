module Isy
  module Widget
    class Inspector < Erector::Widget

      def initialize(obj, method = :pp)
        @obj, @method = obj, method
      end

      def content
        code do
          rawtext(format_dump(get_dump))
        end
      end

      protected

      def format_dump(str)
        str.html_escape.gsub(/ /,'&#160;').gsub(/\r\n?/, "\n").gsub(/\n/, capture {br})
      end

      def get_dump
        case @method
        when :pp
          str = ''
          PP.pp(@obj, str)
          str
        when :p
          @obj.inspect
        else
          raise ArgumentError, "unsuported dump method: #{method.inspect}"
        end
      end

    end
  end
end