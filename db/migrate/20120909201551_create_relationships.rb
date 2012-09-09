class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_id
      t.integer :recipe_id

      t.timestamps
    end

    add_index :relationships, :user_id
    add_index :relationships, :recipe_id
    add_index :relationships, [:user_id, :recipe_id], unique: true
  end
end
