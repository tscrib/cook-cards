# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
	attr_accessible :email, :name, :password, :password_confirmation
	has_secure_password
	#has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "user_id", dependent: :destroy
	has_many :added_recipes, through: :relationships, source: :recipe

	before_save { self.email.downcase! }
	before_save :create_remember_token
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name, presence: true, length: {maximum: 50 }
	validates :email, presence: true, 
			format: { with: VALID_EMAIL_REGEX }, 
			uniqueness: { case_sensitive: false}
	# Removed "presence: true" validator. This is a hack 
	#   to make the error output more readable.
	#   See config/locales/en.yml for the hack
	validates :password, length: { minimum: 6 }
	validates :password_confirmation, presence: true


	# Public Function Definitions
	# def feed
	#     # This is preliminary. See "Following users" for the full implementation.
	#     Micropost.where("user_id = ?", id)
	# end

	def added?( other_recipe )
		relationships.find_by_recipe_id( other_recipe.id )
	end

	def add!( other_recipe )
		relationships.create!( recipe_id: other_recipe.id )
	end

	def remove!(other_recipe)
		relationships.find_by_recipe_id(other_recipe).destroy
	end

	# Private Function Definitions
	private

		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
