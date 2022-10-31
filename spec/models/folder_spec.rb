require 'rails_helper'

RSpec.describe Folder, type: :model do
  describe 'Association' do
    it "User と N:1 の関係である" do
      expect(described_class.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it "Link と 1:N の関係である" do
      expect(described_class.reflect_on_association(:links).macro).to eq :has_many
    end
  end

  describe 'Validation' do
    it '全てのパラメータが正しい場合、有効である' do
      folder = build(:folder)
      expect(folder).to be_valid
    end

    it 'nameがnilの場合、無効である' do
      folder = build(:folder, name: nil)
      expect(folder).to be_invalid
    end

    it 'nameが空白の場合、無効である' do
      folder = build(:folder, name: " ")
      expect(folder).to be_invalid
    end

    it 'nameが空文字の場合、無効である' do
      folder = build(:folder, name: "")
      expect(folder).to be_invalid
    end

    it 'nameが31文字以上の場合、無効である' do
      folder = build(:folder, name: ("a" * 31).to_s)
      expect(folder).to be_invalid
    end

    it 'nameが30文字以下の場合、有効である' do
      folder = build(:folder, name: ("a" * 30).to_s)
      expect(folder).to be_valid
    end

    it 'descriptionがnilの場合、有効である' do
      folder = build(:folder, description: nil)
      expect(folder).to be_valid
    end

    it 'descriptionが空白の場合、有効である' do
      folder = build(:folder, description: " ")
      expect(folder).to be_valid
    end

    it 'descriptionが空文字の場合、有効である' do
      folder = build(:folder, description: "")
      expect(folder).to be_valid
    end

    it 'descriptioonが201文字以上の場合、無効である' do
      folder = build(:folder, description: ("a" * 201).to_s)
      expect(folder).to be_invalid
    end

    it 'descriptionが200文字以下の場合、有効である' do
      folder = build(:folder, description: ("a" * 200).to_s)
      expect(folder).to be_valid
    end
  end
end
