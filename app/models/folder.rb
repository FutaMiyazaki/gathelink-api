class Folder < ApplicationRecord
  MAX_FOLDERS_COUNT = 100
  COLOR_CODE_REGEX = /\A#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})\z/

  belongs_to :user
  has_many :links, dependent: :destroy
  has_many :folder_favorites, dependent: :destroy

  validate :folders_count_must_be_within_limit
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 200 }
  validates :color, format: { with: COLOR_CODE_REGEX }

  scope :created_asc, -> { order(created_at: :asc) }
  scope :created_desc, -> { order(created_at: :desc) }
  scope :name_asc, -> { order(name: :asc) }
  scope :name_desc, -> { order(name: :desc) }

  def folders_count_must_be_within_limit
    errors.add(:base, "フォルダは #{MAX_FOLDERS_COUNT} 個まで作成可能です") if user.folders.count >= MAX_FOLDERS_COUNT
  end

  def self.order_by(sort)
    case sort
    when "created_asc"
      created_asc
    when "created_desc"
      created_desc
    when "name_desc"
      name_desc
    else
      name_asc
    end
  end
end
