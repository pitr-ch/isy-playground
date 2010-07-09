module Isy::Core::Observable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # @return [Array<Symbol>] allowed events
    def observable_events(*events)
      @_observable_events = events unless events.blank?
      return @_observable_events unless @_observable_events.blank?
      raise ArgumentError
    end
  end

  # adds observer to listening to event
  # @param [Symbol] event to observe
  # @param [Object] observer
  # @param [Symbol] method to call on observer
  # @return [Object] observer
  def add_observer(event, observer = nil, method = :update, &block)
    raise ArgumentError unless self.class.observable_events.include? event
    if block
      observer, method = block, :call
    else
      raise NoMethodError, "observer does not respond to `#{method.to_s}'" unless observer.respond_to? method
    end    
    _observers(event)[observer] = method
    observer
  end

  # deletes observer from listening to event
  # @param [Symbol] event to observe
  # @param [Object] observer
  def delete_observer(event, observer)
    _observers(event).delete(observer)
  end

  # @param [Symbol] event to observe
  def notify_observers(event, *arg)    
    _observers(event).each {|observer, method| observer.send method, *arg }
  end

  def count_observers(event)
    _observers(event).size
  end

  private

  def _observers(event)
    raise ArgumentError unless self.class.observable_events.include? event
    @_observers ||= {}
    @_observers[event] ||= {}
  end

end
