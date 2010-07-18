# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class Foo < Isy::Widget::Base
  wrap_in :span
end

describe Isy::Widget::Base do
  describe Foo do
    describe "#to_html" do
      subject { (@widget = Foo.new).to_html }

      it {should == "<span class=\"foo\" id=\"#{@widget.object_id}\"></span>"}
    end    
  end
end

