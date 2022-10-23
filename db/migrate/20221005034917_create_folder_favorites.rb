class CreateFolderFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :folder_favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :folder, null: false, foreign_key: true

      t.timestamps
      t.index [:user_id, :folder_id], unique: true
    end
  end
end
