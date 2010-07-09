require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Isy::Weak::Ref do

  def gc
    ObjectSpace.garbage_collect; ObjectSpace.garbage_collect
  end

  let (:ref) { Isy::Weak::Ref.new([1,2]) }

  describe '#at(0)' do
    subject { ref.at(0) }
    it { should eq(1) }
  end
  
  describe '#[1]' do
    subject { ref[1] }
    it { should eq(2) }
  end

  describe 'after GC' do
    it { lambda { ref[1] }.should raise(RefError) }
  end

end
