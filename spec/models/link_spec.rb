require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:folder) { create(:folder) }

  describe 'Association' do
    it "User と N:1 の関係である" do
      expect(described_class.reflect_on_association(:user).macro).to eq :belongs_to
    end
  end

  describe 'Validation' do
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
      link = build(:link, url: "https://gathelink.app/#{'a' * 1000}")
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

    it "20個目まではリンクの新規作成に成功すること" do
      create_list(:link, 19, folder_id: folder.id)
      link = build(:link, folder_id: folder.id)
      expect do
        link.save!
      end.to change(described_class, :count).by(+1)
    end

    it "21個目のリンクの新規作成には失敗すること" do
      create_list(:link, 20, folder_id: folder.id)
      link = build(:link, folder_id: folder.id)
      expect do
        link.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
