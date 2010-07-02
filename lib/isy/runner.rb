module Isy
    module Runner

      class << self

        def run!
          load_app_files
          Core::Base.run!
          setup_application
          Isy.logger.info Config.to_s
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

      end

    end
end