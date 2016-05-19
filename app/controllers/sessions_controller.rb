require 'digest/sha1'

class SessionsController < ApplicationController
  def new
  end

  def login
  	@user_info = params[:session]

  	@user = User.find_by_email(@user_info[:email])
  	password = Digest::SHA1.hexdigest(@user_info[:password])

	  if @user && @user[:password] == password
	    session[:user_id] = @user.id
	    flash[:success] = "Welcome to the Media Uploader. World's #1 Online Drive!"
	    redirect_to '/'
	  else
	  	flash[:error] = "Error: Please fill the correct information"
	    redirect_to login_path
	  end 
  end

  def destroy 
	  session[:user_id] = nil 
	  redirect_to '/' 
	end

end
