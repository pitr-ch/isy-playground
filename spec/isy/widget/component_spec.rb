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

end
