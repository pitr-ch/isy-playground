# encoding: UTF-8

unless defined? Hammer
  require 'pp'
  #  require 'uuid'
  require 'active_support/core_ext'
  require 'active_support/basic_object'
  require 'erector'
  require 'sinatra/base'
  require 'em-websocket'
  require 'configliere'
  require 'json/pure' # TODO require something faster
  require 'benchmark'
  require 'neverblock'
  require 'observer'  
  #  require 'weakref'

  module Hammer

    def self.logger
      @logger ||= Hammer::Logger.new(Config[:logger][:output])
    end

    def self.v19?
      RUBY_VERSION =~ /1.9/
    end

    def self.benchmark(label, req = true, &block)
      time = Benchmark.realtime { block.call }
      Hammer.logger.info "#{label} in %0.6f sec" % time unless req
      Hammer.logger.info "#{label} in %0.6f sec ~ %d req" % [time, (1/time).to_i] if req
    end

    files = [
      "hammer/widget/base.rb",
      "hammer/widget/component.rb",
      "hammer/widget/collection.rb",
      "hammer/widget/layout.rb",
      "hammer/component/base.rb",
      "hammer/component/developer/gc.rb",
      "hammer/component/developer/tools.rb",
      "hammer/component/developer/log.rb",
      "hammer/component/developer/inspection/object.rb",
      "hammer/component/form_part.rb",
      "hammer/config.rb",
      "hammer/core/base.rb",
      "hammer/core/application/common_logger.rb",
      "hammer/core/action.rb",
      "hammer/core/web_socket/connection.rb",
      "hammer/core/observable.rb",
      "hammer/core/container.rb",
      "hammer/logger.rb",
      "hammer/exception/exceptions.rb",
      "hammer/runner.rb",
      "hammer/widget/optionable_collection.rb",
      "hammer/widget/form_part/abstract.rb",
      "hammer/widget/form_part/textarea.rb",
      "hammer/widget/form_part/select.rb",
      "hammer/component/developer/inspection/array.rb",
      "hammer/component/developer/inspection/hash.rb",
      "hammer/component/developer/inspection/module.rb",
      "hammer/component/developer/inspection/string.rb",
      "hammer/component/developer/inspection/class.rb",
      "hammer/core/context.rb",
      "hammer/core/application.rb",
      "hammer/widget/form_part/input.rb",
      "hammer/component/developer/inspection/numeric.rb",
      "hammer/component/developer/inspection/symbol.rb" ]

    root = File.expand_path("#{File.dirname(__FILE__)}")
    files.each do |file|
      require "#{root}/#{file}"
    end


  end

  # require 'datamapper'
  # require "#{Hammer.root}/lib/setup_db.rb"
  # DataMapper.setup(:default, 'sqlite3://memory')
  # DataMapper.auto_migrate!
end
