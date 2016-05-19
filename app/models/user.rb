require 'digest/sha1'

class User < ActiveRecord::Base

	has_many :mediums

	before_save :encrypt_password
	after_save :clear_password

	EMAIL_REGEX = /^.+@.+$/i
	# validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX


	def encrypt_password
		self.password = Digest::SHA1.hexdigest(password)
	end

	def clear_password
	  self.password = nil
	end
end
