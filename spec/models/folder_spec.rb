require 'rails_helper'

RSpec.describe Folder, type: :model do
  let(:user) { create(:user) }

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

    it 'colorが # から始まらない文字の場合、無効である' do
      folder = build(:folder, color: ("a" * 6).to_s)
      expect(folder).to be_invalid
    end

    it 'colorが # から始まるが、# 以降が1文字の場合、無効である' do
      folder = build(:folder, color: "##{'a' * 1}")
      expect(folder).to be_invalid
    end

    it 'colorが # から始まるが、# 以降が2文字の場合、無効である' do
      folder = build(:folder, color: "##{'a' * 2}")
      expect(folder).to be_invalid
    end

    it 'colorが # から始まるが、# 以降が3文字の場合、有効である' do
      folder = build(:folder, color: "##{'a' * 3}")
      expect(folder).to be_valid
    end

    it 'colorが # から始まるが、# 以降が4文字の場合、無効である' do
      folder = build(:folder, color: "##{'a' * 4}")
      expect(folder).to be_invalid
    end

    it 'colorが # から始まるが、# 以降が5文字の場合、無効である' do
      folder = build(:folder, color: "##{'a' * 5}")
      expect(folder).to be_invalid
    end

    it 'colorが # から始まるが、# 以降が6文字の場合、有効である' do
      folder = build(:folder, color: "##{'a' * 6}")
      expect(folder).to be_valid
    end

    it 'colorが # から始まるが、# 以降が7文字以上の場合、無効である' do
      folder = build(:folder, color: "##{'a' * 7}")
      expect(folder).to be_invalid
    end

    it "100個目まではフォルダの新規作成に成功すること" do
      create_list(:folder, 99, user_id: user.id)
      folder = build(:folder, user_id: user.id)
      expect do
        folder.save!
      end.to change(described_class, :count).by(+1)
    end

    it "101個目のフォルダの新規作成には失敗すること" do
      create_list(:folder, 100, user_id: user.id)
      folder = build(:folder, user_id: user.id)
      expect do
        folder.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
