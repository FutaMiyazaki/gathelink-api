class Link < ApplicationRecord
  validates :url, presence: true, length: { maximum: 1000 }, format: /\A#{URI::regexp(%w(http https))}\z/
  validates :title, presence: true, length: { maximum: 100 }
end
