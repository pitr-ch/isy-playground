require 'sinatra'

set :run, false # don't start server

module Isy
  class Application < Sinatra::Default

    use Rack::Session::Pool

    set(
      :root => Isy.root,
      :public => "#{Isy.root}/public"
    )

    def self.run!(options={})
      puts '== Isy with:'
      super
    end

    def contexts
      session[:contexts] ||= Contexts::Container.new
    end

    def run_action(action_id)
      @context = contexts[1] || contexts.new_context(1, AppLayout, Counter)
      @context.run_action action_id
    end

    before do
      
    end

    get '/' do
      @context.to_s
    end

    get '/do-action/:action_id' do |action_id|
      run_action(action_id)
      @context.to_s
    end

  end
end
