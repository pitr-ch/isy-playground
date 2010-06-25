module Isy
  module Application
    class Base < Sinatra::Base
      use Rack::Session::Pool
      use CommonLogger, Isy.logger

      set(
        :logging => false,
        :server => %w[thin],
        :dump_errors => false
      )

      configure(:development) do
        use Rack::Reloader, 1
      end

      configure(:production) do
        Isy.logger.level = Logger::Severity::INFO
      end

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

      def self.load_app(app_path)
        %w[components layouts widgets].each do |dir|
          load_dir(app_path, dir)
        end
        set :app_file, app_path
      end

      private

      def self.load_dir(app_path, dir)
        require_all "#{File.dirname(app_path)}/#{dir}/**/*.rb" if File.exist?("#{File.dirname(app_path)}/#{dir}")
      end

    end
  end
end
