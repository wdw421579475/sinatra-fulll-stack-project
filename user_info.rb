require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default,ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/gamble.db")

class User_info
    include DataMapper::Resource
    property :User_id, Serial
    property :User_name, String
    property :Password, String
    property :Win, Integer, :default => 0
    property :Lost, Integer, :default => 0
end
DataMapper.auto_upgrade!
DataMapper.finalize

configure :development do
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/gamble.db")
end

configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'])
end
