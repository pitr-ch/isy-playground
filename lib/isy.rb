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
  require 'json'
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

    files = [
      "isy/widget/base.rb",
      "isy/widget/component.rb",
      "isy/widget/collection.rb",
      "isy/widget/layout.rb",
      "isy/component/base.rb",
      "isy/component/developer/gc.rb",
      "isy/component/developer/tools.rb",
      "isy/component/developer/log.rb",
      "isy/component/developer/inspection/object.rb",
      "isy/component/form_part.rb",
      "isy/config.rb",
      "isy/core/base.rb",
      "isy/core/application/common_logger.rb",
      "isy/core/action.rb",
      "isy/core/web_socket/connection.rb",
      "isy/core/observable.rb",
      "isy/core/container.rb",
      "isy/logger.rb",
      "isy/exception/exceptions.rb",
      "isy/runner.rb",
      "isy/widget/optionable_collection.rb",
      "isy/widget/form_part/abstract.rb",
      "isy/widget/form_part/textarea.rb",
      "isy/widget/form_part/select.rb",
      "isy/component/developer/inspection/array.rb",
      "isy/component/developer/inspection/hash.rb",
      "isy/component/developer/inspection/module.rb",
      "isy/component/developer/inspection/string.rb",
      "isy/component/developer/inspection/class.rb",
      "isy/core/context.rb",
      "isy/core/application.rb",
      "isy/widget/form_part/input.rb",
      "isy/component/developer/inspection/numeric.rb",
      "isy/component/developer/inspection/symbol.rb" ]

    #    root = File.expand_path("#{File.dirname(__FILE__)}/..")
    #    require_all "#{root}/lib/isy/**/*.rb"

    root = File.expand_path("#{File.dirname(__FILE__)}")
    files.each do |file|
      require "#{root}/#{file}"
    end


  end

  # require 'datamapper'
  # require "#{Isy.root}/lib/setup_db.rb"
  # DataMapper.setup(:default, 'sqlite3://memory')
  # DataMapper.auto_migrate!
end
