require "mechanize"
require "uri"

class Link < ApplicationRecord
  MAX_LINKS_COUNT = 30

  belongs_to :user
  belongs_to :folder

  validate :links_count_must_be_within_limit
  validates :url, presence: true, length: { maximum: 1000 },
                  format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
  validates :title, presence: true, length: { maximum: 100 }
  validates :image_url, length: { maximum: 2000 }

  scope :created_asc, -> { order(created_at: :asc) }
  scope :created_desc, -> { order(created_at: :desc) }
  scope :title_asc, -> { order(title: :asc) }
  scope :title_desc, -> { order(title: :desc) }

  def links_count_must_be_within_limit
    errors.add(:base, "フォルダには #{MAX_LINKS_COUNT} 個までリンクを追加することが可能です") if folder.links.count >= MAX_LINKS_COUNT
  end

  def self.order_by(sort)
    case sort
    when "created_asc"
      created_asc
    when "created_desc"
      created_desc
    when "title_desc"
      title_desc
    else
      title_asc
    end
  end
end
