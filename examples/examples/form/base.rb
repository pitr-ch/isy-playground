# encoding: UTF-8

module Examples
  module Form
    class Base < Hammer::Component::FormPart

      attr_reader :counter
      def initial_state
        super
        @counter = 0
        @record =  Struct.new("Data", :name, :sex, :description).new
      end

      class Widget < Hammer::Component::FormPart::Widget

        def content
          p do
            text 'name '
            widget Hammer::Widget::FormPart::Input, :value => :name
          end
          p do
            text 'sex '
            widget Hammer::Widget::FormPart::Select, :value => :sex, :select_options => [nil, 'male', 'female']
          end
          p do
            text 'description '
            widget Hammer::Widget::FormPart::Textarea, :value => :description
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
