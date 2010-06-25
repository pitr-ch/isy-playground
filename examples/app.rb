require "rubygems"
require "bundler"
Bundler.setup

require "isy"

class ExamplesApp < Isy::Application::Base
  load_app __FILE__

  self.root_component = Examples
  self.layout = AppLayout
end

ExamplesApp.run!