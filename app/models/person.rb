class Person
  include DataMapper::Resource

  property :id, Serial
  property :first_name, String
  property :last_name, String
  property :nick, String
  
end