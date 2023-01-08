require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'Validation' do
    it '全てのパラメータが正しい場合、有効である' do
      tag = build(:tag)
      expect(tag).to be_valid
    end

    it 'name が nil の場合、無効である' do
      tag = build(:tag, name: nil)
      expect(tag).to be_invalid
    end

    it 'name が空白の場合、無効である' do
      tag = build(:tag, name: " ")
      expect(tag).to be_invalid
    end

    it 'name が空文字の場合、無効である' do
      tag = build(:tag, name: "")
      expect(tag).to be_invalid
    end

    it 'name が21文字以上の場合、無効である' do
      tag = build(:tag, name: ("a" * 21).to_s)
      expect(tag).to be_invalid
    end

    it 'name が20文字以下の場合、有効である' do
      tag = build(:tag, name: ("a" * 20).to_s)
      expect(tag).to be_valid
    end

    it '同じ name を持つ tag は無効である' do
      tag_name = "ライフハック"
      tag = create(:tag, name: tag_name)
      new_tag = build(:tag, name: tag_name)
      expect(new_tag).to be_invalid
    end
  end
end
