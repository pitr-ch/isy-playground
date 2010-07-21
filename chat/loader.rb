files = %w[
  chat/model/user.rb
  chat/model/room.rb
  chat/model/message.rb
  chat/login.rb
  chat/message_form.rb
  chat/room.rb
  chat/rooms.rb
  chat/room_form.rb
  chat/root.rb
  app_layout.rb
]

files.each {|f| require "./#{f}" }