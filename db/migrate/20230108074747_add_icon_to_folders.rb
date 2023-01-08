class AddIconToFolders < ActiveRecord::Migration[7.0]
  def change
    add_column :folders, :icon, :string
  end
end
