require 'rubygems'
require 'sinatra'
require 'active_support'
require 'erector'
require 'relaxdb'


# set indentation for html
Erector::Widget.prettyprint_default = true

# set root to a working directory of the project
root = File.expand_path("#{File.dirname(__FILE__)}/../")
set(
  :root => root,
  :public => "#{root}/public",
  :server => 'mongrel'
)

use Rack::Session::Pool#, :domain => 'pitr.sytes.net', :expire_after => 60 * 60 * 24 * 7 # week

# set load_paths
ActiveSupport::Dependencies.load_paths += [
  "#{root}/lib",
  "#{root}/erector",
  "#{root}/model",
]

require 'routes.rb'