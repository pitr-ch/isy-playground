require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')

describe Isy::Component::Developer::Inspection::Object do

  class InspectTest
    @array = [1]
  end

  let(:inspector) { Isy::Component::Developer::Inspection::Object.new(nil, InspectTest) }

  subject { inspector }

  describe '#obj' do
    subject { inspector.obj }
    it { should eql(InspectTest) }
  end
  
  describe '#components' do
    subject { inspector.components }
    it { should be_empty }
    it { should be_kind_of(Array) }
  end  

  describe 'when unpacked' do
    before { inspector.switch_packed }

    describe '#components' do
      subject { inspector.components }
      
      it { should_not be_empty }
      it { should be_kind_of(Array) }
      it { should have(1).items }

      describe '#first' do
        subject { inspector.components.first }
        it { should be_kind_of(Isy::Component::Developer::Inspection::Hash) }

        describe '#label' do
          subject { inspector.components.first.label }
          it { should == 'Instance variables' }
        end

        describe '#obj' do
          subject { inspector.components.first.obj }
          it { should be_kind_of ::Hash }

          describe '#keys' do
            subject { inspector.components.first.obj.keys }
            it { should include(:@array) }
          end          
        end
      end

    end

  end


end

