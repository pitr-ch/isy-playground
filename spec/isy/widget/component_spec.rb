# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


describe Isy::Widget::Component do

  include IsyMocks

  describe "#widget" do
    subject do
      Isy::Widget::Component.new(:component => component_mock) do |w|
        w.widget(Isy::Widget::Component) {|w| w.text w.c.object_id }
      end.to_html
    end
    it('should pass :component to subwidget') { should match(/#{component_mock.object_id}/) }
  end

  describe '#a' do
    subject { Isy::Widget::Component.new(:component => component_mock) {|w| w.a 'test' }.to_html }
    it { should match(/href="#"/) }
  end

  describe 'callbacks' do
    before { context_mock.stub!(:register_action).and_return('uuid') }

    describe 'when action' do
      subject do
        Isy::Widget::Component.new(:component => component_mock) {|w| w.a 'test', :click => w.send(:do_action) {} }.to_html
      end
      it { should match(/data-callback-click="{&quot;action&quot;:&quot;uuid&quot;}"/)}
    end

    describe 'when form' do
      subject do
        Isy::Widget::Component.new(:component => component_mock) do |w|
          w.a 'test', :click => w.send(:actualize_form, 123)
        end.to_html
      end
      it { should match(/data-callback-click="{&quot;form&quot;:123}"/)}
    end

    describe 'when both' do
      subject do
        Isy::Widget::Component.new(:component => component_mock) do |w|
          w.a 'test', :change => [ w.send(:actualize_form, 123), w.send(:do_action) {} ]
        end.to_html
      end
      it { should match(/data-callback-change="{&quot;form&quot;:123,&quot;action&quot;:&quot;uuid&quot;}"/) }
    end
  end

end
