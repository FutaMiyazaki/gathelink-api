class AddFolderRefToLinks < ActiveRecord::Migration[7.0]
  def change
    add_reference :links, :folder, null: false, foreign_key: true
  end
end
