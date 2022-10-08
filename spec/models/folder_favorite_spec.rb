require 'rails_helper'

RSpec.describe FolderFavorite, type: :model do
  describe 'Association' do
    it "User と N:1 の関係である" do
      expect(described_class.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it "Folder と N:1 の関係である" do
      expect(described_class.reflect_on_association(:folder).macro).to eq :belongs_to
    end
  end

  describe 'Validation' do
    let(:folder_favorite) { create(:folder_favorite) }
    it '全てのパラメータが正しい場合、有効である' do
      expect(folder_favorite).to be_valid
    end

    it 'user_id が nil の場合、無効である' do
      folder_favorite.user_id = nil
      expect(folder_favorite).to be_invalid
    end

    it 'folder_id が nil の場合、無効である' do
      folder_favorite.folder_id = nil
      expect(folder_favorite).to be_invalid
    end
  end
end
