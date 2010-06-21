require 'rubygems'
require 'bundler'
Bundler.setup

require 'pp'
require 'uuid'
require 'active_support/core_ext'
require 'erector'
require 'sinatra/base'
require 'require_all'

Erector::Widget.prettyprint_default = true

module Isy
  def self.root
    @root ||= File.expand_path("#{File.dirname(__FILE__)}/..")
  end

  def self.generate_id
    #    @last_id ||= 0
    #    (@last_id += 1).to_s(36)
    UUID.generate(:compact).to_i(16).to_s(36)
  end

  #  def self.logger
  #    @logger ||= ActiveSupport::BufferedLogger.new($stdout)
  #  end

  $LOAD_PATH << "#{Isy.root}/lib"

  require_all "#{Isy.root}/lib/isy/**/*.rb"
  require_all "#{Isy.root}/app/**/*.rb"

end

require 'isy/application'

#require 'datamapper'
#require "#{Isy.root}/lib/setup_db.rb"
