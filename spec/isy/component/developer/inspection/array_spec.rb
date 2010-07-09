require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')

describe Isy::Component::Developer::Inspection::Array do

  def self.array
    [:symbol, "str", 1]
  end
  def array; self.class.array; end

  let(:inspector) { Isy::Component::Developer::Inspection::Array.new(nil, array) }
  subject { inspector }

  describe '#obj' do
    subject { inspector.obj }
    it { should eql(array) }
  end

  describe 'when unpacked' do
    before { inspector.switch_packed }

    describe '#components' do
      subject { inspector.components }
      it { should have(array.size).items }
      it { subject.each_with_index {|c, i| c.obj.should eql(array[i]) }}

      array.each_with_index do |elem, i|
        describe "#at(#{i})" do

          let(:types) { {0 => Symbol, 1 => String, 2 => Numeric} }

          subject { inspector.components[i] }
          it { should be_kind_of("Isy::Component::Developer::Inspection::#{types[i]}".constantize) }

          describe '#obj' do
            subject { inspector.components[i].obj }
            it { should eql(array[i]) }
          end
        end
      end


    end
  end

end

