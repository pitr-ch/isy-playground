DataMapper.setup(:default, 'postgres://postgres:postgres@localhost/akce_development')

Person

DataMapper.auto_migrate!
