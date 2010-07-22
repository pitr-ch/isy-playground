# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hammer::Widget::Base do
  module Foo
    class FooWidget < Hammer::Widget::Base
      wrap_in :span
    end
    class BooWidget < Hammer::Widget::Base
    end
  end

  describe Foo::BooWidget, "#to_html", 'when wrap_in(nil)' do
    subject { (@widget = Foo::BooWidget.new).to_html }
    it { should == "" }
  end

  describe Foo::FooWidget do
    describe ".css_class" do
      subject { Foo::FooWidget.css_class }
      it { should == 'foo-foo_widget' }
    end

    describe "wrap_in", "#to_html" do
      subject { (@widget = Foo::FooWidget.new).to_html }
      it { should == "<span class=\"#{Foo::FooWidget.css_class}\" id=\"#{@widget.object_id}\"></span>" }

      describe 'when subwidget' do
        subject { (@widget = Foo::FooWidget.new {|w| w.widget @subwidget = Foo::FooWidget.new }).to_html }
        it { should == "<span class=\"#{Foo::FooWidget.css_class}\" id=\"#{@widget.object_id}\">" +
              "<span class=\"#{Foo::FooWidget.css_class}\" id=\"#{@subwidget.object_id}\"></span></span>"}
      end
    end

    describe '.wrapped_in' do
      subject { Foo::FooWidget.wrapped_in }
      it { should == :span}
    end

    describe '#render' do
      describe "(a_widget)" do
        subject { (@widget = Foo::FooWidget.new {|w| w.render @subwidget = Foo::FooWidget.new }).to_html }
        it { should == "<span class=\"#{Foo::FooWidget.css_class}\" id=\"#{@widget.object_id}\">" +
              "<span class=\"#{Foo::FooWidget.css_class}\" id=\"#{@subwidget.object_id}\"></span></span>"}
      end

      describe "(a_object_responding_to_widget)" do

        class ObjectWithWidget
          def widget
            @number = 3
            Erector.inline(:obj => @number) { text @obj }
          end
        end

        subject { (@widget = Foo::FooWidget.new {|w| w.render @obj = ObjectWithWidget.new }).to_html }
        it { should == "<span class=\"#{Foo::FooWidget.css_class}\" id=\"#{@widget.object_id}\">3</span>"}
      end

      describe "(other)" do
        subject { lambda { Foo::FooWidget.new {|w| w.render Object.new }.to_html} }
        it { should raise_error(ArgumentError) }
      end
    end
  end
end

