# encoding: UTF-8
# == Schema Information
#
# Table name: recipes
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  title       :string(255)
#  ingredients :text
#  directions  :text
#  photo_url   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


class Recipe < ActiveRecord::Base
	belongs_to :user
	attr_accessible :directions, :ingredients, :photo_url, :title

	VALID_URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*‌​)?/ix

	validates :user_id, presence: true
	validates :title, presence: true
	validates :directions, presence: true
	validates :photo_url, presence: true, format: { with: VALID_URL_REGEX }

end
