class Counters::Counter < Counter

  # we need to store @counters_collection to know where to delete itself
  attr_reader :counters_collection

  def initialize(context, counters_collection)
    super(context)
    @counters_collection = counters_collection
  end

  # we could use ::Counter::Widget but this si much nore flexible
  class Widget < superclass.widget_class

    # here we overwrite actions and to add Remove link
    def actions
      link_to('Remove') { @counters_collection.remove(self) }
    end
  end
end