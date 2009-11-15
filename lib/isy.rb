require 'rubygems'
require 'uuid'
require 'pp'
require 'active_support'

require 'erector'
Erector::Widget.prettyprint_default = true


module Isy
  def self.root
    @root ||= File.expand_path("#{File.dirname(__FILE__)}/..")
  end

  def self.logger
    @logger ||= ActiveSupport::BufferedLogger.new($stderr)
  end
end

require 'isy/application'
#require 'isy/components'
#require 'isy/widgets'
require 'isy/contexts'

ActiveSupport::Dependencies.load_paths += [
  "#{Isy.root}/lib",
  "#{Isy.root}/app/components",
  "#{Isy.root}/app/widgets",
  "#{Isy.root}/app/models",
  "#{Isy.root}/app/layouts"
]


#ActiveSupport::Dependencies.log_activity = true
#ActiveSupport::Dependencies.logger = Isy.logger
