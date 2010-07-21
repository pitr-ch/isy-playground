# encoding: UTF-8

module Isy
  Config = Configliere.new({
      :web => {
        :host => '0.0.0.0',
        :port => 3000
      },
      :websocket => {
        :host => '0.0.0.0',
        :server => '127.0.0.1',
        :port => 3001,
        :debug => false,
        :fibers => 10,
      },
      :layout_class => 'Isy::Widget::Layout',
      :environment => :development,
      :js => { :send_log_back => false },
      :logger => {
        :level => 0,
        :show_traffic => false,
        :output => $stdout
      },
      :core => { :devel => 'devel' }
    })

  Config.use :env_var
  Config.env_vars :environment => ENV['RACK_ENV']
  Config.resolve!
    
  Config.use :config_file
  Config.read './config.yml'
  Config.resolve!

  Config.use :define
  Config.define 'web.host', :require => true, :type => String
  Config.define 'web.port', :require => true, :type => Integer
  Config.define 'websocket.host', :require => true, :type => String
  Config.define 'websocket.server', :require => true, :type => String
  Config.define 'websocket.port', :require => true, :type => Integer
  Config.define 'websocket.debug', :require => true, :type => :boolean
  Config.define 'websocket.fibers', :require => true, :type => Integer
  Config.define 'root_class', :require => true, :type => String
  Config.define 'layout_class', :require => true, :type => String,
      :description => "Name of a layout class."
  Config.define 'environment', :require => true, :type => Symbol
  Config.define 'js.send_log_back', :require => true, :type => :boolean
  Config.define 'logger.level', :require => true, :type => Integer
  Config.define 'logger.show_traffic', :require => true, :type => :boolean
  Config.define 'logger.output', :require => true
  Config.define 'core.devel', :require => true, :type => String
  Config.resolve!
  
  Config.use :commandline
  Config.resolve!  
end



