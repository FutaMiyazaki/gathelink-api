class AddIndexFolderIdAndTagIdToFolderTaggings < ActiveRecord::Migration[7.0]
  def change
    add_index :folder_taggings, %i[folder_id tag_id], unique: true
  end
end
