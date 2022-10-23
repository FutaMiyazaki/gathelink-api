# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :links, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :folder_favorites, dependent: :destroy
  has_many :favorite_folders, through: :folder_favorites, source: :folder

  validates :name, length: { maximum: 20 }

  def self.guest
    find_or_create_by!(email: "guest@gathelink.app") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end
end
