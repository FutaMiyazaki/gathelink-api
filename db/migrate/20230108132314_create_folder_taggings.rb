class CreateFolderTaggings < ActiveRecord::Migration[7.0]
  def change
    create_table :folder_taggings do |t|
      t.references :folder, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
