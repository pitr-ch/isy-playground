class Work
  include DataMapper::Resource

  property :id, Serial
  property :issue, Integer
  property :minutes, Integer


  
end