class FolderTagging < ApplicationRecord
  belongs_to :folder
  belongs_to :tag

  validates :folder_id, uniqueness: { scope: :tag_id }
end
