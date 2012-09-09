class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer :user_id
      t.string :title
      t.text :ingredients
      t.text :directions
      t.string :photo_url

      t.timestamps
    end

    # Indexes
    add_index :recipes, [:title, :created_at]
  end
end
