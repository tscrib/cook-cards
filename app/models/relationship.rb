# == Schema Information
#
# Table name: relationships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  recipe_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Relationship < ActiveRecord::Base
  attr_accessible :recipe_id, :user_id

  belongs_to :user, class_name: "User"
  belongs_to :recipe, class_name: "Recipe"

  validates :user_id, presence: true
  validates :recipe_id, presence: true

end
