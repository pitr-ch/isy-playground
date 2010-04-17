#!/usr/bin/ruby1.9.1

require "#{File.dirname(__FILE__)}/lib/isy"

class IsyRun < Isy::Application
  state_on '/', Counters::Base
#  state_on '/counters', Counters::Base
#  state_on '/times', Times::Base
end

IsyRun.run!