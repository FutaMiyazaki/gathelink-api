class Folder < ApplicationRecord
  MAX_FOLDERS_COUNT = 50
  COLOR_CODE_REGEX = /\A#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})\z/

  belongs_to :user
  has_many :links, dependent: :destroy
  has_many :folder_favorites, dependent: :destroy
  has_many :folder_taggings, dependent: :destroy
  has_many :tags, through: :folder_taggings

  validate :folders_count_must_be_within_limit
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 200 }
  validates :color, format: { with: COLOR_CODE_REGEX }
  validates :icon, length: { maximum: 30 }

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

  def save_tags(sent_tags)
    current_tags = []
    current_tags = tags.pluck(:name) unless tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      tags.delete Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_folder_tag = Tag.find_or_create_by(name: new)
      tags << new_folder_tag
    end
  end
end
