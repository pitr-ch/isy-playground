class AbstractWidget < Erector::Widget

  def a(action_block, *args, &block)
    uuid = UUID.generate
    register_action(uuid, action_block)

    url = {:href => "?action=#{uuid}"}
    if args.last.is_a?(Hash)
      args.last.merge url
    else
      args.push url
    end
    
    super(*args, &block)
  end

  protected

  def session
    parent.session || raise(RuntimeError, "session missing")
  end

  def register_action(uuid, block)
    session[:actions] ||= {}
    session[:actions][uuid] = Action.new(uuid, self, block)
  end

  Action = Struct.new 'Action', :uuid, :instance, :block
  class Action
    def call
      instance.send :instance_eval, &block
    end
  end
end