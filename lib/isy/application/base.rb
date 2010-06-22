module Isy
  module Application
    class Base < Sinatra::Base
      use Rack::Session::Pool

      set(
        :root => Isy.root,
        :public => "#{Isy.root}/public",
        :logging => false
      )

      def self.run!(options={})
        puts '== Isy with:'
        super
      end

      def contexts
        session[:contexts] ||= Context::Container.new
      end

      def context
        contexts[params[:context_id]]
      end

      def run_action
        context && context.run_action(params[:action_id])
      end

      def initialize(app=nil)
        super(app)
        after_initialize
      end

      def after_initialize      
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
end
