require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validation' do
    it '全てのパラメータが正しい場合、有効である' do
      link = build(:link)
      expect(link).to be_valid
    end

    it 'urlがnilの場合、無効である' do
      link = build(:link, url: nil)
      expect(link).to be_invalid
    end

    it 'urlが空白の場合、無効である' do
      link = build(:link, url: " ")
      expect(link).to be_invalid
    end

    it 'urlが空文字の場合、無効である' do
      link = build(:link, url: "")
      expect(link).to be_invalid
    end

    it 'urlが1000文字以上の場合、無効である' do
      link = build(:link, url: "https://gathelink.app/" + "a" * 1000)
      expect(link).to be_invalid
    end

    it 'urlが1000文字未満の場合、有効である' do
      link = build(:link, url: "https://gathelink.app/")
      expect(link).to be_valid
    end

    it 'titleがnilの場合、無効である' do
      link = build(:link, title: nil)
      expect(link).to be_invalid
    end

    it 'titleが空白の場合、無効である' do
      link = build(:link, title: " ")
      expect(link).to be_invalid
    end

    it 'titleが空文字の場合、無効である' do
      link = build(:link, title: "")
      expect(link).to be_invalid
    end

    it 'titleが101文字以上の場合、無効である' do
      link = build(:link, title: "a" * 101)
      expect(link).to be_invalid
    end

    it 'titleが100文字以下の場合、有効である' do
      link = build(:link, title: "a" * 100)
      expect(link).to be_valid
    end
  end
end
