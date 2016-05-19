class UsersController < ApplicationController
	puts session[:user_id].nil?

  def index
  end

  def new
  	@user = User.new
  end

  def create_user
  	@new_user = User.new(params[:user])

  	if @new_user
  		@new_user[:role] = "user" if @new_user.role.nil?
  		if @new_user.save
  			session[:user_id] = @new_user.id
  			system 'mkdir', '-p', Rails.root.join('public', 'images/uploads/', session[:user_id].to_s)
        flash[:success] = "Welcome to the Media Uploader. World's #1 Online Drive!"
  		end
  	end

  	redirect_to "/"
  end

end
