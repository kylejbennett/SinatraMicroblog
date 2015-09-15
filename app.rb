require	'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'rack-flash'

use Rack::Flash, :sweep => true

set :database, 'sqlite3:microdb.sqlite3'

set :sessions, true

configure(:development){set :database, "sqlite3:microdb.sqlite3"}

def current_user 
	if session[:userid]
		@current_user = User.find(session[:userid])
	end
end	

get "/" do 
	@posts = Post.all
	@profiles = Profile.all
	erb :signin
end

get "/account" do 
	erb :account
end

get "/feed" do 
	@posts = Post.all
	erb :feed
end

get "/follow" do 
	erb :follow
end

get "/loginfail" do 
	erb :loginfail
end

get "/post" do 
	flash[:notice] = "User signed in successfully."
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

post '/sign-in' do   
	@user = User.where(username: params[:username]).first   
	if @user && @user.password == params[:password]     
		session[:user_id] = @user.id     
		flash[:notice] = "You've been signed in successfully."   
	else     
		flash[:alert] = "There was a problem signing you in."   
	end   
	redirect "/" 
end

post "/feed" do
	p = {
		:post_title=> params["post_title"],
		:post_content=> params["post_content"],
		:userid=> params["userid"],
	}
	Post.create(p)
	@posts = Post.all
	erb :feed
end

