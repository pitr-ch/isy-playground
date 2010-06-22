module Isy
  module Application
    class Default < Base
      use CommonLogger, Isy.logger

      configure(:development) do
        use Rack::Reloader, 1
      end

      configure(:production) do
        Isy.logger.level = Logger::Severity::INFO
      end
    end
  end
end