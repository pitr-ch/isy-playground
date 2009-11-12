require 'rubygems'
require 'uuid'

module Isy
  def self.root
    @root ||= File.expand_path("#{File.dirname(__FILE__)}/..")
  end
end

require 'isy/application'
require 'isy/components'
require 'isy/layout'
require 'isy/contexts'

require 'active_support'

ActiveSupport::Dependencies.load_paths += [
  "#{Isy.root}/app/components",
  "#{Isy.root}/app/models",
  "#{Isy.root}/app/layouts"
]


