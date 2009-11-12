module Isy
  module Contexts
    class Action
      attr_reader :id, :component, :block

      def initialize(uuid, component, block)
        @uuid, @component, @block = uuid, component, block
      end

      def call
        puts "exetuing action #{id} in #{component.class} returning:"
        puts \
            component.send(:instance_eval, &block)
      end
    end
  end
end
