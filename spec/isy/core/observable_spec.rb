# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Isy::Core::Observable do

  class AObservable
    include Isy::Core::Observable
    observable_events :a_event
  end

  let(:a_observable) { AObservable.new }

  describe '.observable_events' do
    subject { AObservable.observable_events }
    it { should == [:a_event] }
  end

  describe '#add_observer' do
    describe '(:a_event, a_observer, a_method)' do
      let(:observer) { mock(:observer, :on_event => nil) }
      before { a_observable.add_observer(:a_event, observer, :on_event) }
      it('should add observer') do
        a_observable.send(:_observers, :a_event).should include(observer)
      end

      describe 'when notified' do
        before { observer.should_receive :on_event }
        it { lambda { a_observable.notify_observers :a_event }.should_not raise_error }
      end

      describe 'when deleted' do
        before { a_observable.delete_observer(:a_event, observer) }
        it { a_observable.send(:_observers, :a_event).should be_blank }
      end
    end

    describe '(:a_event) { raise \'called\' }' do
      before { a_observable.add_observer(:a_event) { raise 'called' }}
      it { lambda { a_observable.notify_observers :a_event }.should raise_error(RuntimeError, 'called') }
    end
  end

  

end