class Folder < ApplicationRecord
  belongs_to :user
  has_many :links, dependent: :destroy
  has_many :folder_favorites, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 200 }

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
end
