class AddDescriptionToFolders < ActiveRecord::Migration[7.0]
  def change
    add_column :folders, :description, :string
  end
end
