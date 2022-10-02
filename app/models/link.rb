class Link < ApplicationRecord
  belongs_to :user
  belongs_to :folder

  validates :url, presence: true, length: { maximum: 1000 },
                  format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
  validates :title, presence: true, length: { maximum: 100 }
end
