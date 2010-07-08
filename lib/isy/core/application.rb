# encoding: UTF-8

module Isy
  module Core
    class Application < Sinatra::Base
      use CommonLogger, Isy.logger
      use Rack::Session::Pool
      
      set(
        :logging => false,
        :server => %w[thin]
      )

      configure(:development) do
        use Rack::Reloader, 1
      end

      configure(:production) do
        Isy.logger.level = Logger::Severity::INFO
      end

      # @return [String] session_id
      def session_id
        request.session_options[:id]
      end

      get '/' do
        Config[:layout_class].to_s.constantize.new(:session_id => session_id).to_s
      end

      # monkey patch sintra .run!
      def self.run!(options={})
        set options
        handler = detect_rack_handler
        handler_name = handler.name.gsub(/.*::/, '')

        Isy.logger.info "== Isy WebServer" +
            " on #{port} for #{environment} with backup from #{handler_name}" unless handler_name =~/cgi/i

        handler.run self, :Host => host, :Port => port do |server|
          trap(:INT) do
            ## Use thins' hard #stop! if available, otherwise just #stop
            server.respond_to?(:stop!) ? server.stop! : server.stop
            Isy.logger.info "== Isy has ended" unless handler_name =~/cgi/i
          end
          set :running, true
        end
      rescue Errno::EADDRINUSE => e
        Isy.logger.error "port #{port} taken!"
      end
    end
  end
end
