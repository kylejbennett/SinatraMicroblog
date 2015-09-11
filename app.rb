require	'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, 'sqlite3:microdb.sqlite3'

get "/" do 
	erb :signin
end

get "/account" do 
	erb :account
end

get "/feed" do 
	erb :feed
end

get "/follow" do 
	erb :follow
end

get "/loginfail" do 
	erb :loginfail
end

get "/post" do 
	erb :post
end

get "/profiles" do 
	erb :profiles
end