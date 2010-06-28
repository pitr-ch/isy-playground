require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class Foo < Isy::Widget::Base
  wrap_in :span
end

describe Isy::Widget::Base do
  describe Foo do
    describe "#to_s" do
      subject { Foo.new.to_s }

      it {should == "<span class=\"foo\"></span>"}
    end    
  end
end

