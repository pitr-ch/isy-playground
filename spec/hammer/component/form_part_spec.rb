# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hammer::Component::FormPart do
  include HammerMocks

  class TestForm < Hammer::Component::FormPart

    def initial_state
      @record = Struct.new(:record, :value, :name).new
    end

    class Widget < Hammer::Component::FormPart::Widget
    end

  end

  let(:test_form) { TestForm.new(context_mock, @id = Object.new) }

  describe '#set_value and #value' do
    describe "('value')" do
      before { test_form.set_value 'value' }
      subject { test_form.value }
      it { should == 'value' }
    end

    describe "(:name, 'name')" do
      before { test_form.set_value :name, 'name' }
      subject { test_form.value :name }
      it { should == 'name' }
    end
  end

  describe '#to_html' do
    subject { test_form.to_html }
    it { should match(/data-form-id="#{test_form.form.object_id}"/) }
    it { should match(/data-component-id="#{test_form.object_id}"/) }
  end

end