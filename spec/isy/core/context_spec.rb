# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Isy::Core::Context do
  include IsyMocks

  let(:allocated_context) { Isy::Core::Context.allocate }
  let(:context) { allocated_context.send :initialize, @id = 'id', container_mock, ''; allocated_context }
  #  let(:context) { Isy::Core::Context.new @id = 'id', container_mock, '' }

  describe '.new' do
    describe '#id' do
      it { context.id.should == 'id' }
    end

    describe '#container' do
      it { context.container.should == container_mock }
    end

    describe '#hash' do
      it { context.hash.should == '' }
    end

  end

  describe '.no_connection_contexts' do
    it { context.class.no_connection_contexts.should include(context) }

    describe 'when dropped' do
      before { context.should_receive(:notify_observers).with(:drop, context) }
      before { context.drop }      
      it { context.class.no_connection_contexts.should_not include(context) }
    end
  end

  describe 'when connection is set' do
    before { context.connection = mock(:connection) }

    describe '.no_connection_contexts' do
      it { context.class.no_connection_contexts.should_not include(context) }
    end

    describe '.by_connection' do
      it { context.class.by_connection(context.connection).should == context }

      describe 'when dropped' do
        before { context.should_receive(:notify_observers).with(:drop, context) }
        before { context.drop }
        it { context.class.by_connection(context.connection).should be_nil }
      end
    end
  end

  describe '#actualize' do
    class AComponent < Isy::Component::Base
      class Widget < Isy::Widget::Base
        def content
          text 'a component'
        end
      end
    end

    before do
      allocated_context.should_receive(:root_class).and_return(AComponent)
      context.connection = mock(:connection)
      context.actualize
    end
    subject { context.instance_variable_get(:@message)[:html] }

    it { should_not be_nil }
    it { should match(/a component/) }

    describe 'when sended' do
      before { context.connection.should_receive(:send) }
      before { context.send! }
      it { context.instance_variable_get(:@message).should == {} }
    end
  end

  describe '#send_id' do
    before { context.send_id(mock(:connection)) }
    it { context.instance_variable_get(:@message).should == {:context_id => 'id'} }
  end

  describe '#schedule' do
    before { $blocks = [] }
    describe 'when one block' do
      before do
        context.schedule { $blocks << :first }
      end
      it('should execute the block ') { $blocks.should == [:first] }
    end

    describe 'when two block' do
      before do
        context.schedule { $blocks << :first }
        context.schedule { $blocks << :second }
      end
      it('should execute the block ') { $blocks.should == [:first, :second] }
    end

    describe 'when first block is paused' do
      before do
        context.schedule do
          $blocks << :first
          $fiber = Fiber.current
          Fiber.yield
          $blocks << :third
        end
        context.schedule { $blocks << :second; $fiber.resume }
      end
      it('should execute the block ') { $blocks.should == [:first] }
    end

    describe 'when first block is paused and resumed' do
      before do
        context.schedule do
          $blocks << :first
          $fiber = Fiber.current
          Fiber.yield
          $blocks << :third
        end
        context.schedule { $blocks << :second }
        $fiber.resume
      end
      it('should execute the block ') { $blocks.should == [:first, :third, :second] }
    end
  end

  describe '#update_form' do
    before do
      form_part = mock(:form_part)
      form_part.should_recieve.(:set_value).with(:name, 'name')
      form_part.should_recieve.(:set_value).with(:value, 'value')
      context.update_form(:id => form_part.object_id, :name => 'name', :value => 'value')
    end
  end


end
