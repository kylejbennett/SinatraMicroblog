require	'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, 'sqlite3:microdb.sqlite3'

configure(:development){set :database, "sqlite3:microdb.sqlite3"}

get "/" do 
	@posts = Post.all
	@profiles = Profile.all
	erb :signin
end

get "/account" do 
	erb :account
end

get "/feed" do 
	@post = Post.all
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
	@users = User.all
	erb :profiles
end

post "/signin" do
	u = {
		:email=> params["email"],
		:username=> params["username"],
		:password=> params["password"]
	}
	User.create(u)
	puts @users.inspect
	erb :post
end