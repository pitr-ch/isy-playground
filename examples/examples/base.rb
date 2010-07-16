# encoding: UTF-8
module Examples
  class Base < Isy::Component::Base

    attr_reader :example

    def initial_state
      @example = nil
    end

    class Widget < Isy::Widget::Component
      def content
        strong 'Examples:'
        ul do
          li { a "Counters", :click => do_action { @example = new Counters::Base } }
          li { a "#ask", :click => do_action { @example = new Ask::Base } }
          li { a "form", :click => do_action { @example = new Form::Base } }
          li { a "none", :click => do_action { @example = nil } }
        end
        hr

        render component.example if component.example
      end
    end

  end
end
