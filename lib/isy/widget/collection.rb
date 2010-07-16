# encoding: UTF-8

module Isy
  module Widget

    # Abstract widget to render collections
    class Collection < Component

      needs :collection => nil

      # @return [Array<Erector::Widget, Component::Base>, nil] obtained collection of widgets/components
      def collection
        @collection || component.try(:collection) || raise(ArgumentError, "failed to obtain collection")
      end

      def content
        before
        if collection.blank?
          nothing
        elsif collection.size == 1
          render collection.first
        else
          render collection.first
          collection[1..-1].each do |element|
            between
            render element
          end
        end
        after
      end

      protected

      # overwrite to render stuff before collection
      def before; end
      # overwrite to render stuff after collection
      def after; end
      # overwrite to render stuff between collection's elements
      def between; end
      # overwrite to render stuff when collection is blank
      def nothing; end

    end
  end
end
