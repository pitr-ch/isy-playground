# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'rack/test'


describe Hammer::Core::Application do
  include Rack::Test::Methods

  def app
    Hammer::Core::Application
  end

  it "returns layout" do
    get '/'
    last_response.should be_ok
    last_response.body.should match(/js\/hammer.js/)
  end
  
end

