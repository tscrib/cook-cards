class AddIndexToRecipesTitle < ActiveRecord::Migration
  def change
  	add_index :recipes, :title
  end
end
