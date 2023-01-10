class Tag < ApplicationRecord
  has_many :folder_taggings, dependent: :destroy
  has_many :folders, through: :folder_taggings

  validates :name, uniqueness: true, presence: true, length: { maximum: 20 }
end
