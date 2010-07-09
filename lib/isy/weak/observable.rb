#module Isy
#  module Weak
#    module Observable
#
#
#      def add_observer(observer, func=:update)
#        @observer_peers = {} unless defined? @observer_peers
#        unless observer.respond_to? func
#          raise NoMethodError, "observer does not respond to `#{func.to_s}'"
#        end
#        @observer_peers[WeakRef.new(observer)] = func
#      end
#
#      #
#      # Delete +observer+ as an observer on this object. It will no longer receive
#      # notifications.
#      #
#      def delete_observer(observer)
#        @observer_peers.delete observer.object_id if defined? @observer_peers
#      end
#
#      #
#      # Delete all observers associated with this object.
#      #
#      def delete_observers
#        @observer_peers.clear if defined? @observer_peers
#      end
#
#      #
#      # Return the number of observers associated with this object.
#      #
#      def count_observers
#        if defined? @observer_peers
#          @observer_peers.size
#        else
#          0
#        end
#      end
#
#      #
#      # Set the changed state of this object.  Notifications will be sent only if
#      # the changed +state+ is +true+.
#      #
#      def changed(state=true)
#        @observer_state = state
#      end
#
#      #
#      # Query the changed state of this object.
#      #
#      def changed?
#        if defined? @observer_state and @observer_state
#          true
#        else
#          false
#        end
#      end
#
#      #
#      # If this object's changed state is +true+, invoke the update method in each
#      # currently associated observer in turn, passing it the given arguments. The
#      # changed state is then set to +false+.
#      #
#      def notify_observers(*arg)
#        if defined? @observer_state and @observer_state
#          if defined? @observer_peers
#            @observer_peers.inject([]) do |garbage, pair|
#              k,v = pair
#              if k.weakref_alive?
#                k.send v, *arg
#              else
#                garbage << k
#              end
#              garbage
#            end.each {|garbage| delete_observer(garbage) }
#          end
#          @observer_state = false
#        end
#      end
#
#    end
#
#  end
#end