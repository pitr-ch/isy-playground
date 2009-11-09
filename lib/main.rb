# framework part
require 'rubygems'
require 'sinatra'
require 'active_support'
require 'erector'
require 'uuid'
require 'contexts_container'

# app part
# require 'relaxdb' # for CouchDB
# TODO couch or datamapper ?

# set indentation for html
Erector::Widget.prettyprint_default = true

root = File.expand_path("#{File.dirname(__FILE__)}/../")
set(
  :root => root,
  :public => "#{root}/public",
  :server => 'mongrel'
)

# use inmemory sessions
use Rack::Session::Pool

# set load_paths
ActiveSupport::Dependencies.load_paths += [
  "#{root}/lib",
  "#{root}/app/components",
  "#{root}/app/models",
  "#{root}/app/layouts",
]

def contexts
  session[:contexts] ||= ContextsContainer.new
end

# retrieve action and execute
before do
  puts "params[:action] = #{params[:action].inspect}"
  @context = contexts[1] || contexts.new_context(1, AppLayout, Counter)
  @context.run_action params[:action]
end

require 'routes.rb'