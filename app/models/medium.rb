class Medium < ActiveRecord::Base
	belongs_to :users

	# Validation
	validates :name, :presence => true
	validates :user_id, :presence => true
	validates :filename, :presence => true
	validates_associated :users

	def upload_file(fileObj, user_id)
		if fileObj
	 		# Modify the filname in case of duplicates
	 		filename = avoidDuplicates(fileObj.original_filename, user_id)

  		File.open(Rails.root.join('public', 'images/uploads/', user_id.to_s, filename), 'w') do |file|
	      file.write(fileObj.read)
	    end 
	    # Save the file info into database
	    self[:name] = fileObj
      self[:user_id] = user_id
      self[:filename] = filename
      self[:mime_type] = fileObj.content_type

      if self.save
      	true
      else
      	flash[:error] = "Problem in saving file"
      	false
      end
    else
    	flash[:error] = "Please select file to upload"
    	false
    end
	end

	def avoidDuplicates(filename, user_id)
		fExt = File.extname(filename)
		fName = File.basename(filename, fExt)
		isFileExist = Medium.where(:user_id => user_id, :filename => filename)

		if isFileExist.size > 0
			moreFileExist = Medium.where(["filename LIKE ?", "%#{fName}_copy%"]).where(:user_id => user_id)
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
end
