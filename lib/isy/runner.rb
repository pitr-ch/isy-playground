# encoding: UTF-8

module Isy
  module Runner

    class << self

      def run!
        #          encoding
          
        load_app_files
        Core::Base.run!
        setup_application
        Isy.logger.info "== Settings\n" + Config.pretty_inspect
        Isy.logger.level = Config[:logger][:level]
        Core::Application.run!
      end

      private

      def load_app_files
        %w[components layouts widgets].each do |dir|
          require_all "./#{dir}/**/*.rb" if File.exist?("./#{dir}")
        end
      end

      def setup_application
        Core::Application.set \
            :root => Dir.pwd,
            :host => Config[:web][:host],
            :port => Config[:web][:port],
            :environment => Config[:web][:environment]
      end

      def encoding
        puts "External encoding: #{Encoding.default_external.inspect}"
        puts "Internal encoding: #{Encoding.default_internal.inspect}"
      end

    end

  end
end