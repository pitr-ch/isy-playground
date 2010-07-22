# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


describe Hammer::Widget::Component do

  include HammerMocks

  describe "#widget" do
    subject do
      Hammer::Widget::Component.new(:component => component_mock) do |w|
        w.widget(Hammer::Widget::Component) {|w| w.text w.c.object_id }
      end.to_html
    end
    it('should pass :component to subwidget') { should match(/#{component_mock.object_id}/) }
  end

  describe '#a' do
    subject { Hammer::Widget::Component.new(:component => component_mock) {|w| w.a 'test' }.to_html }
    it { should match(/href="#"/) }
  end

end
