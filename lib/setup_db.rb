DataMapper.setup(:default, 'sqlite3://memory')

Work

DataMapper.auto_migrate!
