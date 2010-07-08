# encoding: UTF-8

module Isy
  class Logger

    module Severity
      DEBUG   = 0
      INFO    = 1
      WARN    = 2
      ERROR   = 3
      FATAL   = 4
      UNKNOWN = 5
    end
    include Severity
    include Observable

    ##
    # :singleton-method:
    # Set to false to disable the silencer
    cattr_accessor :silencer
    self.silencer = true

    # Silences the logger for the duration of the block.
    def silence(temporary_level = ERROR)
      if silencer
        begin
          old_logger_level, self.level = level, temporary_level
          yield self
        ensure
          self.level = old_logger_level
        end
      else
        yield self
      end
    end

    attr_accessor :level

    def initialize(log, level = DEBUG)
      @level = level
      @start_buffer = []
      @ready = false
      @log = log
      #      EM.schedule do
      #        EM.attach(log) do |connection|
      #          Isy.logger.instance_eval do
      #            @log = connection
      #            flush_start_buffer
      #          end
      #        end
      #      end
    end

    def add(severity, message = nil, progname = nil, &block)
      return if @level > severity
      message = (message || (block && block.call) || progname).to_s
      message += (message[-1] == ?\n ? '' : "\n")
      changed
      notify_observers(message)
      #      unless @log
      #        @start_buffer << message
      #        return
      #      else
      #        @log.send_data(message)
      #      end
      @log.write message
    end

    # Dynamically add methods such as:
    # def info
    # def warn
    # def debug
    for severity in Severity.constants
      class_eval <<-EOT, __FILE__, __LINE__ + 1
        def #{severity.downcase}(message = nil, progname = nil, &block) # def debug(message = nil, progname = nil, &block)
          add(#{severity}, message, progname, &block)                   #   add(DEBUG, message, progname, &block)
        end                                                             # end

        def #{severity.downcase}?                                       # def debug?
          #{severity} >= @level                                         #   DEBUG >= @level
        end                                                             # end
      EOT
    end
    
    def exception(e)
      error "#{e.class}: #{e.message}\n" + e.backtrace.map {|line| "  "+line }.join("\n")
    end

    private

    #    def flush_start_buffer
    #      @start_buffer.each do |message|
    #        @log.send_data(message)
    #      end
    #      @start_buffer = nil
    #    end

  end

  
end

