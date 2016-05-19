class UsersController < ApplicationController
  def index
  end

  def new
  	@user = User.new
  end

  def create_user
  	@new_user = User.new(params[:user])

  	if @new_user.email != "" && !@new_user.password != ""
  		@new_user[:role] = "user" if @new_user.role.nil?
  		if @new_user.save
  			session[:user_id] = @new_user.id
        puts "VOila"
  			system 'mkdir', '-p', Rails.root.join('public', 'images/uploads/', session[:user_id].to_s)
        flash[:success] = "Welcome to the Media Uploader. World's #1 Online Drive!"
        redirect_to "/"
      else
        flash[:error] = "Wrong Input Or User is Already registered"
        redirect_to "/signup"
  		end
    else
      flash[:error] = "Wrong Input"
      redirect_to "/signup"
  	end
  end

end
