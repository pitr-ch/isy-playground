# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hammer::Core::Base do
  describe '.container' do
    describe 'when container don\'t exist' do
      it { Hammer::Core::Base.container('id').should be_kind_of(Hammer::Core::Container) }
    end

    describe 'when container exist' do
      before { @container = Hammer::Core::Base.container('id') }
      it { Hammer::Core::Base.container('id').should == @container }
    end
  end

  describe '.drop_container' do
    before do
      @container = Hammer::Core::Base.container('id')
      Hammer::Core::Base.drop_container @container
    end
    it { Hammer::Core::Base.instance_variable_get(:@containers).should be_empty }
  end

  describe '.safely' do
    subject { lambda{ Hammer::Core::Base.safely {raise} } }
    before { Hammer.logger.should_receive :exception }
    it { should_not raise_error }
    it { subject.call.should == false }
  end

  describe '.receive_message' do
    let(:connection) { mock(:connection) }
    describe 'without session' do
      before { Hammer.logger.should_receive :add }
      it { Hammer::Core::Base.send :receive_message, {}, connection }
    end

    describe 'without action or form' do
      before do
        connection.should_receive(:send).with(hash_including(:context_id, :html))
        Hammer::Core::Base.send :receive_message, {'session_id' => 'session_id', 'hash' => 'devel'}, connection
        @container = Hammer::Core::Base.container('session_id')
        @context = @container.instance_variable_get(:@contexts).values.first
      end
      it { @context.connection.should == connection }

      describe 'with action' do
        before do
          @context.should_receive(:run_action).with('action_id').and_return(@context)
          connection.should_receive(:send).with(hash_including(:html))
          Hammer::Core::Base.send(:receive_message, {
              'session_id' => 'session_id',
              'context_id' => @context.id,
              'action_id' => 'action_id',
              'hash' => 'devel'},
            connection)
        end
      end

      describe 'with form' do
        before do
          @context.should_receive(:update_form).with('form_id').and_return(@context)
          connection.should_receive(:send).with(hash_including(:html))
          Hammer::Core::Base.send(:receive_message, {
              'session_id' => 'session_id',
              'context_id' => @context.id,
              'form' => 'form_id',
              'hash' => 'devel'},
            connection)
        end
      end

      describe 'with action and form' do
        before do
          @context.should_receive(:update_form).with('form_id').and_return(@context)
          @context.should_receive(:run_action).with('action_id').and_return(@context)
          connection.should_receive(:send).with(hash_including(:html))
          Hammer::Core::Base.send(:receive_message, {
              'session_id' => 'session_id',
              'context_id' => @context.id,
              'form' => 'form_id',
              'hash' => 'devel'},
            connection)
        end
      end
    end
  end

  pending '.run_websocket_server'
end
