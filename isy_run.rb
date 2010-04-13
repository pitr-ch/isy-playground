#!/usr/bin/ruby

require "#{File.dirname(__FILE__)}/lib/isy"

class IsyRun < Isy::Application
  state_on '/', TestApp
end

IsyRun.run!