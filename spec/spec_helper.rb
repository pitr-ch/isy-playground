# encoding: UTF-8

require "#{File.dirname(__FILE__)}/../lib/isy"

module IsyMocks
  def self.included(base)
    base.let(:container_mock) { mock(:container, :drop_context => true) }
    base.let(:context_mock) { mock(:context, :conteiner => container_mock) }
    base.let(:component_mock) { mock(:component, :context => context_mock) }
  end
end

RSpec.configure do |config|
  config.mock_with :rspec
end