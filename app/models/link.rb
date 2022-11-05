class Link < ApplicationRecord
  MAX_LINKS_COUNT = 30

  belongs_to :user
  belongs_to :folder

  validate :links_count_must_be_within_limit
  validates :url, presence: true, length: { maximum: 1000 },
                  format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
  validates :title, presence: true, length: { maximum: 100 }

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }

  def links_count_must_be_within_limit
    errors.add(:base, "フォルダには #{MAX_LINKS_COUNT} 個までリンクを追加することが可能です") if folder.links.count >= MAX_LINKS_COUNT
  end
end
