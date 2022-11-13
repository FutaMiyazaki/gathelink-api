class AddImageUrlToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :image_url, :text
  end
end
