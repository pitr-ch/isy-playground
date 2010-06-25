raise "wrong ruby version #{RUBY_VERSION}" unless RUBY_VERSION =~ /1\.9/

require 'uuid'
require 'active_support/core_ext'
require 'erector'
require 'sinatra/base'
require 'require_all'

Erector::Widget.prettyprint_default = true # TODO remove after adding ajax

module Isy
  def self.root
    @root ||= File.expand_path("#{File.dirname(__FILE__)}/..")
  end

  def self.generate_id
    #    @last_id ||= 0
    #    (@last_id += 1).to_s(36)
    UUID.generate(:compact).to_i(16).to_s(36)
  end

  def self.logger
    @logger ||= Logger.new($stdout)
  end

  require_all "#{Isy.root}/lib/isy/**/*.rb"
end

# require 'datamapper'
# require "#{Isy.root}/lib/setup_db.rb"
# DataMapper.setup(:default, 'sqlite3://memory')
# DataMapper.auto_migrate!
