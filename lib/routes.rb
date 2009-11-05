before do
  @root_widget = session[:root_widget] ||= Layout.new
  @root_widget.session = session
end

# retrieve action
before do
  puts "params[:action] = #{params[:action].inspect}"
  if session[:actions] && params[:action]
    @action = session[:actions][params[:action]]
  end
  session[:actions] = {}
end

# execute action
before do
  puts "action_returns: #{@action.call.inspect}" if @action
end

get '/' do
  puts "session = #{session.inspect}"
  @root_widget.to_s
end