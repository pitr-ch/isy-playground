#!/usr/bin/ruby1.9.1

require "#{File.dirname(__FILE__)}/lib/isy"

class IsyRun < Isy::Application
  self.root_component = Examples
  self.layout = AppLayout
end

IsyRun.run!