class Folder < ApplicationRecord
  belongs_to :user
  has_many :links, dependent: :destroy
  has_many :folder_favorites, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
end
