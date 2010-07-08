# encoding: UTF-8

class Ask::Counter < ::Counter

  def initialize(context, number = 0)
    super(context)
    @counter = number
  end

  class Widget < superclass.widget_class
    
    # adds links to answer the number (counter) or
    # to answer nothing.
    # Everything else is as we need.
    def actions
      link_to('Add number') { answer!(counter) }
      link_to('Cancel') { answer! }
    end
  end
end
