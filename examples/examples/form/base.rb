# encoding: UTF-8

module Examples
  module Form
    class Base < Isy::Component::FormPart

      attr_reader :counter
      def initial_state
        super
        @counter = 0
        @record =  Struct.new("Data", :name, :sex, :description).new
      end

      class Widget < Isy::Component::FormPart::Widget

        def content
          p do
            text 'name '
            widget Isy::Widget::FormPart::Input, :value => :name
          end
          p do
            text 'sex '
            widget Isy::Widget::FormPart::Select, :value => :sex, :select_options => [nil, 'male', 'female']
          end
          p do
            text 'description '
            widget Isy::Widget::FormPart::Textarea, :value => :description
          end

          cb.a("Send for the #{counter}th time").event(:click).form.action! { @counter += 1 }

          h4 'Values:'
          ul do
            li value(:name).inspect
            li value(:sex).inspect
            li value(:description).inspect
          end          
          
        end
      end

    end
  end
end
