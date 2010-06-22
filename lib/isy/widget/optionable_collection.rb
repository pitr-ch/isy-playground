module Isy
  module Widget

    # Collection with options ability
    class OptionableCollection < Collection

      # @option options [Erector::Widget, Isy::Component::Base] :before renders before collection
      # @option options [Erector::Widget, Isy::Component::Base] :after renders after collection
      # @option options [Erector::Widget, Isy::Component::Base] :between renders between collection's elements
      # @option options [Erector::Widget, Isy::Component::Base] :nothing renders when collection is blank
      def initialize(component, collection = nil, options = {})
        super component, collection
        @options = options
      end

      protected

      %w[before, after, between, nothing].map(&:to_sym).each do |method|
        define_method method do widget options[method] if options[method] end
      end
    end
    OCollection = OptionableCollection
  end
end
