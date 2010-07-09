# encoding: UTF-8

unless defined? Isy
  require 'pp'
  require 'uuid'
  require 'active_support/core_ext'
  require 'active_support/basic_object'
  require 'erector'
  require 'sinatra/base'
  require 'require_all'
  require 'em-websocket'
  require 'configliere'
  require 'json' # TODO load something faster
  require 'benchmark'
  require 'neverblock'
  require 'observer'  
  require 'weakref'

  module Isy

    def self.logger
      @logger ||= Isy::Logger.new($stdout)
    end

    def self.v19?
      RUBY_VERSION =~ /1.9/
    end

    def self.benchmark(label, req = true, &block)
      time = Benchmark.realtime { block.call }
      Isy.logger.info "#{label} in %0.6f sec" % time unless req
      Isy.logger.info "#{label} in %0.6f sec ~ %d req" % [time, (1/time).to_i] if req
    end

    root = File.expand_path("#{File.dirname(__FILE__)}/..")
    require_all "#{root}/lib/isy/**/*.rb"
  end

  # require 'datamapper'
  # require "#{Isy.root}/lib/setup_db.rb"
  # DataMapper.setup(:default, 'sqlite3://memory')
  # DataMapper.auto_migrate!
end
