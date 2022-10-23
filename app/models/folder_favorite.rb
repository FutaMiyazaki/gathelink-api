class FolderFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :folder

  validates :folder_id, uniqueness: { scope: :user_id }
end
