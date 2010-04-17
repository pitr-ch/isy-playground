module Times
  class UnsavedTimes < Isy::Components::Component

    def initialize(parent, work = nil)
      @work = work || ::Work.new
    end

  end
end