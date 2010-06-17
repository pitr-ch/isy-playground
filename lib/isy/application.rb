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

    class_inheritable_accessor(:root_component)
    class_inheritable_accessor(:layout)

    get '/' do      
      if context
        context.to_s
      else
        contexts.new_context(
          self.class.layout,
          self.class.root_component).to_s
      end      
    end

  end
end
