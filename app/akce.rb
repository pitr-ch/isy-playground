require "#{File.dirname(__FILE__)}/../lib/isy"

class Akce < Isy::Application
  state_on '/', Testicek
end

Akce.run!