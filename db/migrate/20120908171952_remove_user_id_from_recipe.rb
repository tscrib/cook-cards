class RemoveUserIdFromRecipe < ActiveRecord::Migration
  def up
    remove_column :recipes, :user_id
  end

  def down
    add_column :recipes, :user_id, :integer
  end
end
