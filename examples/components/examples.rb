# encoding: UTF-8

class Examples < Isy::Component::Base

  attr_reader :example

  def initial_state
    @example = nil
  end

  class Widget < Isy::Widget::Component
    def content
      strong 'Examples:'
      ul do
        li { link_to("Counters") { @example = new Counters::Base } }
        li { link_to("#ask") { @example = new Ask::Base } }
        li { link_to("none") { @example = nil } }
      end
      hr

      render component.example if component.example
    end
  end

end
