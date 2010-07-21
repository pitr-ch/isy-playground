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
          li { cb.a("Counters").event(:click).action! { @example = new Counters::Base } }
          li { cb.a("#ask").event(:click).action! { @example = new Ask::Base } }
          li { cb.a("form").event(:click).action! { @example = new Form::Base } }
          li { cb.a("none").event(:click).action! { @example = nil } }
        end
        hr

        render example if example
      end
    end

  end
end
