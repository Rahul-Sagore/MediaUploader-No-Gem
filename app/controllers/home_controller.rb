class HomeController < ApplicationController
	before_filter :user_logged_in
  def index
  	@new_media = Medium.new

  	if @current_user[:role] == 'admin'
  		@media = Medium.all
  	else
	  	@user = User.find(session[:user_id])
	  	@media = @user.mediums
	  end
  end

  def upload
  	@media = Medium.new
  	fileObj = params[:new_media][:name]

  	if @media.upload_file(fileObj, session[:user_id])
  		flash[:success] = "File Successfully uploaded"
		end

		redirect_to :action => "index"
	end


	def download
		@media = Medium.find_by_id(params[:media])
		begin
			send_file Rails.root.join('public', 'images/uploads/', session[:user_id].to_s, @media.filename), :x_sendfile=>true
		rescue
			flash[:error] = "File Not Available to download"
			redirect_to :action => "index"
		end
	end

end
