class Counters::Counter < Counter

  attr_reader :counters_base 

  def initialize(context, counters_base)
    super(context)
    @counters_base = counters_base
  end

  class Widget < superclass.widget_class

    def actions
      link_to('Remove') { @counters_base.remove(self) }
    end
  end
end