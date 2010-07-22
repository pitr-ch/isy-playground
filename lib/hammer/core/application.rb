# encoding: UTF-8

module Hammer
  module Core
    class Application < Sinatra::Base
      use CommonLogger, Hammer.logger
      use Rack::Session::Pool
      
      set(
        :logging => false,
        :server => %w[thin]
      )

      configure(:development) do
        use Rack::Reloader, 1
      end

      configure(:production) do
        Hammer.logger.level = Logger::Severity::INFO
      end

      # @return [String] session_id
      def session_id
        request.session_options[:id]
      end

      get '/' do
        Config[:layout_class].to_s.constantize.new(:session_id => session_id).to_html
      end

      # monkey patch sintra .run!
      def self.run!(options={})
        set options
        handler = detect_rack_handler
        handler_name = handler.name.gsub(/.*::/, '')

        Hammer.logger.info "== Hammer WebServer" +
            " on #{port} for #{environment} with backup from #{handler_name}" unless handler_name =~/cgi/i

        handler.run self, :Host => host, :Port => port do |server|
          trap(:INT) do
            ## Use thins' hard #stop! if available, otherwise just #stop
            server.respond_to?(:stop!) ? server.stop! : server.stop
            Hammer.logger.info "== Hammer has ended" unless handler_name =~/cgi/i
          end
          set :running, true
        end
      rescue Errno::EADDRINUSE => e
        Hammer.logger.error "port #{port} taken!"
      end
    end
  end
end
