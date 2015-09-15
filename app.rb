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
	@profiles = Profile.all 
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
	if current_user
		@posts = Post.all
		flash[:notice] = "User signed in successfully."
		erb :feed
	else
		flash[:notice] = "Please login or sign up"
		redirect '/'
	end
	erb :post
end

get "/profiles" do 
	@users = User.all
	erb :profiles
end

get "/sign-out" do
	session[:userid] = nil
	flash[:notice] = "You've been signed OUT successfully."
	erb :signin
end

get "/userpage" do
	@profiles = Profile.all
	erb :account
end
 
post "/signup" do
	u = {
		:email=> params["email"],
		:username=> params["username"],
		:password=> params["password"]
	}
	@user = User.create(u)
	session[:userid] = @user.id 
	puts @user.id
	erb :post
end

post '/sign-in' do   
	@user = User.where(username: params[:username]).first   
	if @user && @user.password == params[:password]     
		session[:userid] = @user.id     
		flash[:notice] = "You've been signed in successfully."
		redirect "/post"   
	else     
		flash[:alert] = "There was a problem signing you in."   
	end   
	redirect "/" 
end

post "/feed" do
	
	if current_user
		@post = Post.new(params)
		@post.userid = current_user.id
	end
	if @post.save
		redirect '/feed'
	else
		redirect '/post'
	end
end

