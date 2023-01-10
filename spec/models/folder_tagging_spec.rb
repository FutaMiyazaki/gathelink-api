require 'rails_helper'

RSpec.describe FolderTagging, type: :model do
  describe 'Association' do
    it "Folder と 1:N の関係である" do
      expect(described_class.reflect_on_association(:folder).macro).to eq :belongs_to
    end

    it "Tag と 1:N の関係である" do
      expect(described_class.reflect_on_association(:tag).macro).to eq :belongs_to
    end
  end

  describe 'Validation' do
    let!(:folder_tagging) { create(:folder_tagging) }
    let(:new_folder_tagging) do
      build(:folder_tagging, folder_id: folder_tagging.folder_id, tag_id: folder_tagging.tag_id)
    end

    it '全てのパラメータが正しい場合、有効である' do
      expect(folder_tagging).to be_valid
    end

    it 'folder_id が nil の場合、無効である' do
      folder_tagging.folder_id = nil
      expect(folder_tagging).to be_invalid
    end

    it 'tag_id が nil の場合、無効である' do
      folder_tagging.tag_id = nil
      expect(folder_tagging).to be_invalid
    end

    context 'folder_id と tag_id の組み合わせが重複している場合' do
      it '無効である' do
        expect(new_folder_tagging).to be_invalid
      end

      it 'DB への保存時にエラーが発生する' do
        expect do
          new_folder_tagging.save(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
