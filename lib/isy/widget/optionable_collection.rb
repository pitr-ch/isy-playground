# encoding: UTF-8

module Isy
  module Widget

    # Collection with options ability
    class OptionableCollection < Collection
      # @param [Hash] options defines what will be rendered before, after, between or when nothing
      # @option options [Erector::Widget, Component::Base, String, Proc] :before renders before collection
      # @option options [Erector::Widget, Component::Base, String, Proc] :after renders after collection
      # @option options [Erector::Widget, Component::Base, String, Proc] :between renders between collection's elements
      # @option options [Erector::Widget, Component::Base, String, Proc] :nothing renders when collection is blank
      # @example
      #     OCollection.new(users, nil,
      #       :before => 'Users:',
      #       :nothing => 'No users.',
      #       :after => lambda {|w| w.p { text "count: #{w.collection.count}" }}
      #     )
      def initialize(component, collection = nil, options = {})
        super component, collection
        @options = options
      end

      protected

      %w[before, after, between, nothing].map(&:to_sym).each do |method|
        define_method method do 
          case options[method]
          when String then text options[method]
          when Proc then options[method].call(self)
          else render options[method]
          end
        end
      end
    end
    OCollection = OptionableCollection
  end
end
