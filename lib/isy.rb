require 'rubygems'
require 'pp'

require 'uuid'
require 'active_support'
require 'erector'

Erector::Widget.prettyprint_default = true


module Isy
  def self.root
    @root ||= File.expand_path("#{File.dirname(__FILE__)}/..")
  end

  #  def self.logger
  #    @logger ||= ActiveSupport::BufferedLogger.new($stdout)
  #  end
end

$LOAD_PATH << "#{Isy.root}/lib"

ActiveSupport::Dependencies.load_paths += [
  "#{Isy.root}/lib",
  "#{Isy.root}/app/components",
  "#{Isy.root}/app/widgets",
  "#{Isy.root}/app/models",
  "#{Isy.root}/app/layouts"
]

require 'isy/application'
#require 'isy/components'
#require 'isy/widgets'
require 'isy/contexts'

require 'datamapper'
require "#{Isy.root}/lib/setup_db.rb"
