# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hammer::Core::Container do
  let(:container) { Hammer::Core::Container.new('id') }

  describe '.new' do
    describe('#id') { it { container.id.should == 'id' }}
    describe('@contexts') { it { container.instance_variable_get(:@contexts).should be_empty }}
  end

  describe '#context' do
    describe '(nil, "")' do
      it { container.context(nil, "").should be_kind_of(Hammer::Core::Context) }
    end

    describe "(a_id, '')" do
      before { @context = container.context(nil, "") }
      it { container.context(@context.id).should == @context }
    end
  end

  describe '#restart_context' do
    before do
      @context1 = container.context(nil, "")
      @context1.connection = mock(:connection)
      Hammer::Core::Context.
          should_receive(:new).
          with(@context1.id, container, @context1.hash).
          and_return(@context2 = 
            mock(:restarted_content, :id => @context1.id, :container => container, :hash => @context1.hash))
      @context2.should_receive(:connection=).with(@context1.connection)
      @context2.stub(:connection).and_return(@context1.connection)
      @context2.should_receive(:schedule)
      container.restart_context(@context1.id, @context1.hash, @context1.connection)
    end

    describe 'restarted context' do
      it('should have same id') { container.context(@context1.id).id == @context1.id }
      it('should be different objects') { container.context(@context1.id).should_not eql(@context1) }
      it('should have same connection') { container.context(@context1.id).connection eql(@context1.connection) }
    end
  end

  describe '#drop_context' do
    before do
      @context1 = container.context(nil, "")
      @context2 = container.context(nil, "")
    end

    describe 'when first dropped' do
      before { container.drop_context(@context1) }
      it { container.instance_variable_get(:@contexts).should have(1).items }
      it { container.instance_variable_get(:@contexts)[@context1.id].should be_nil }
      it { container.instance_variable_get(:@contexts)[@context2.id].should == @context2 }

      describe 'when second dropped' do
        before do
          container.should_receive :drop
          container.drop_context(@context2) 
        end
        it { container.instance_variable_get(:@contexts).should be_empty }
      end
    end
  end

  

end
