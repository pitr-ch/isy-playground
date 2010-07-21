# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'benchmark'

describe Isy::Widget::Component::Callback do
  include IsyMocks

  let(:callback) { Isy::Widget::Component::Callback.new(mock(:widget)) }

  describe '#simple_json' do
    it { callback.send(:simple_json, :action => "asd").should == '{"action":"asd"}' }
    it { callback.send(:simple_json, :form => 12).should == '{"form":12}' }
    it { callback.send(:simple_json, :action => "asd", :form => 12).should == '{"action":"asd","form":12}' }
  end

  describe '#flush!' do
    before { context_mock.stub(:register_action).and_return('id') }
    subject do
      @widget = Isy::Widget::Component.new(:component => component_mock) do |w|
        w.cb.a("label", :class => 'a').event(:click).action! {}
        w.cb.span(:class => 'b') { w.text 'content'}.event(:click).form!('id')
      end
      @widget.to_html
    end

    it { should == "<div class=\"isy-widget-component\" id=\"#{@widget.object_id}\">" +
          "<a class=\"a\" data-callback-click=\"{&quot;action&quot;:&quot;id&quot;}\" href=\"#\">label</a>" +
          "<span class=\"b\" data-callback-click=\"{&quot;form&quot;:&quot;id&quot;}\">content</span></div>" }
    
  end

end