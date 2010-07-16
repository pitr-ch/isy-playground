# encoding: UTF-8

module Isy
  module Widget

    # Collection with options ability
    class OptionableCollection < Collection
      
      # @param [Hash] assigns defines what will be rendered before, after, between or when nothing
      # @option assigns [Erector::Widget, Component::Base, String, Proc] :before renders before collection
      # @option assigns [Erector::Widget, Component::Base, String, Proc] :after renders after collection
      # @option assigns [Erector::Widget, Component::Base, String, Proc] :between renders between collection's elements
      # @option assigns [Erector::Widget, Component::Base, String, Proc] :nothing renders when collection is blank
      # @example
      #     OCollection.new(
      #       :component => users,
      #       :before => 'Users:',
      #       :nothing => 'No users.',
      #       :after => lambda {|w| w.p { text "count: #{w.collection.count}" }}
      #     )
      def initialize(assigns = {}, &block)
        super
      end

      protected

      %w[before, after, between, nothing].map(&:to_sym).each do |method|
        define_method method do 
          case value = instance_variable_get(:"@#{method}")
          when String then text value
          when Proc then value.call(self)
          else render value
          end
        end
      end
    end
    OCollection = OptionableCollection
  end
end
