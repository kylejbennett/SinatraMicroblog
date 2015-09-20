require	'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'rack-flash'

use Rack::Flash, :sweep => true

set :sessions, true

configure(:development){set :database, "sqlite3:microdb.sqlite3"}

def current_user 
	if session[:userid]
		@current_user = User.find(session[:userid])
	else
		nil
	end
end	

get "/" do 
	@posts = Post.all
	@profiles = Profile.all
	erb :signin
end

get "/account" do
	if current_user
		@user = current_user
		erb :account
	else
		flash[:notice] = "Please login or sign up"
		redirect '/'
	end
	
end

get "/feed" do 	
	@posts = Post.last(10)
	erb :feed	
end

get "/follow" do 
	erb :follow
end

get "/loginfail" do 
	erb :loginfail
end

get "/edit" do
	@user = current_user
	erb :edit
end

post "/profile/edit" do
	u = {
		:email=> params["email"],
		:username=> params["username"],
	}
	current_user.update(u)
	flash[:notice] = "Profile updated successfully."
	redirect to '/'
end

get "/post" do 
	if current_user
		@posts = Post.all
		erb :post
	else
		flash[:notice] = "Please login or sign up"
		redirect '/'
	end
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

get "/users/:id" do
	begin
		@user = User.find(params[:id])
		erb :user_info
	rescue
		flash[:notice] = "That user does not exist"
		redirect "/"
	end
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
	flash[:notice] = "You are now logged in"
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
		redirect "/"
	end   
	 
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

