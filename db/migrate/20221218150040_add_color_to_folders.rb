class AddColorToFolders < ActiveRecord::Migration[7.0]
  def change
    add_column :folders, :color, :string
  end
end
