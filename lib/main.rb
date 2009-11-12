require 'isy'

Isy::Application.run!

## framework part
#
## app part
## TODO couch or datamapper ?
## require 'relaxdb' # for CouchDB
#require('dm-core')
#
#
## set load_paths
#ActiveSupport::Dependencies.load_paths += [
#  "#{root}/lib",
#  "#{root}/app/components",
#  "#{root}/app/models",
#  "#{root}/app/layouts",
#]
#ActiveSupport::Dependencies.log_activity = true
##ActiveSupport::Dependencies.logger = logger
#
#
## retrieve action and execute
#
#require 'setup_db.rb'
#require 'routes.rb'