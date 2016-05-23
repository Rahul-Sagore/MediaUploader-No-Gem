require 'digest/sha1'

class User < ActiveRecord::Base

	has_many :mediums

	before_save :encrypt_password
	after_save :after_save

	validates :email, :presence => true, :uniqueness => true
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

	private

		def encrypt_password
			self.password = Digest::SHA1.hexdigest(password)
		end

		def after_save
			session[:user_id] = self.id
	  	system 'mkdir', '-p', Rails.root.join('public', 'images/uploads/', session[:user_id].to_s)
		end
end
