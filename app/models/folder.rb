class Folder < ApplicationRecord
  MAX_FOLDERS_COUNT = 100

  belongs_to :user
  has_many :links, dependent: :destroy
  has_many :folder_favorites, dependent: :destroy

  validate :folders_count_must_be_within_limit
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 200 }

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }

  def old_order_links
    links.old.as_json(expect: %i[user_id])
  end

  def folders_count_must_be_within_limit
    errors.add(:base, "フォルダは #{MAX_FOLDERS_COUNT} 個まで作成可能です") if user.folders.count >= MAX_FOLDERS_COUNT
  end
end
