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
	  if params[:new_media]
	  	fileObj = params[:new_media][:name]     

		 	if fileObj
		 		# Write the uploaded file
		 		filename = avoidDuplicates(fileObj.original_filename)

		 		if filename
			 		File.open(Rails.root.join('public', 'images/uploads/', session[:user_id].to_s, filename), 'w') do |file|
			      file.write(fileObj.read)
			    end 

			    # Save the file info into database
			 		@create_media = Medium.new(params[:new_media])
	        @create_media[:user_id] = session[:user_id]
	        @create_media[:filename] = filename
	        @create_media[:mime_type] = fileObj.content_type

	        @create_media.save
	      else
	      	flash[:error] = "Duplicate file"
	      end
	    end
	  else
	  	flash[:error] = "Please select file to upload"
		end

		redirect_to :action => "index"
	end

	def avoidDuplicates(filename)
		fExt = File.extname(filename)
		fName = File.basename(filename, fExt)
		isFileExist = Medium.where(:user_id => session[:user_id], :filename => filename)

		if isFileExist.size > 0
			moreFileExist = Medium.where(["filename LIKE ?", "%#{fName}_copy%"]).where(:user_id => session[:user_id])
			if moreFileExist.size > 0
				lastEntry = moreFileExist[-1].filename
			else
			 	lastEntry = isFileExist[-1].filename
			end
			ext = File.extname(lastEntry)
			fBasename = File.basename(lastEntry, ext)
			pat = fBasename.match(/(_copy)[0-9]*/)

			if !pat.nil?
				pat = pat.to_s
				copy = [pat.slice(0..4), pat.slice(5..-1)]
				#Slicng for double digit replcement
				fBasename[-copy[1].size..-1] = (copy[1].to_i + 1).to_s + ext
				fBasename
			else
				fBasename + "_copy1" + ext
			end
		else
			filename
		end
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
