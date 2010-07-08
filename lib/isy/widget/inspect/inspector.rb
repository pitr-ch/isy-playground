# encoding: UTF-8

require 'pp'

module Isy
  module Widget

    # renders inspection of a object
    class Inspector < Base

      # @param [Object] obj to be inspected
      # @param [Symbol] method of inspection. Supported are :pp and :p
      def initialize(obj, method = :pp)
        super()
        @obj, @method = obj, method
      end

      def content
        code do
          rawtext(format_dump(get_dump))
        end
      end

      protected

      # preserve indentation and new lines for html
      # @param [String] str inspection output
      # @return [String]
      def format_dump(str)
        str.html_escape.gsub(/ /,'&#160;').gsub(/\r\n?/, "\n").gsub(/\n/, capture {br})
      end

      # @return [String] inspection selected by @method
      def get_dump
        case @method
        when :pp then PP.pp(@obj, str = ''); str
        when :p  then @obj.inspect
        else
          raise ArgumentError, "unsuported dump method: #{method.inspect}"
        end
      end

    end
  end
end