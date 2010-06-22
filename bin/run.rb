raise "wrong ruby version #{RUBY_VERSION}" unless RUBY_VERSION =~ /1\.9/

require "#{File.dirname(__FILE__)}/../lib/isy"

class ExamplesApp < Isy::Application::Base
  self.root_component = Examples
  self.layout = AppLayout
end

ExamplesApp.run!