require 'sinatra/base'

module Isy
  class Application < Sinatra::Base

    use Rack::Session::Pool

    set(
      :root => Isy.root,
      :public => "#{Isy.root}/public",
      :logging => true
    )

    def self.run!(options={})
      puts '== Isy with:'
      super
    end

    def contexts
      session[:contexts] ||= Contexts::Container.new
    end

    def context
      contexts[params[:context_id]]
    end

    def run_action
      context && context.run_action(params[:action_id])
    end

    before do
      run_action
    end

    def self.state_on(path, klass, opts={}, &block)
      get path, opts do
        if context
          context.to_s
        else
          contexts.new_context(klass).to_s
        end
      end
    end

  end
end
