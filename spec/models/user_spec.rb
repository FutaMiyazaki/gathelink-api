require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Association' do
    it "Link と 1:N の関係である" do
      expect(described_class.reflect_on_association(:links).macro).to eq :has_many
    end
  end

  describe 'Validation' do
    it '全てのパラメータが正しい場合、有効である' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'nameが21文字以上の場合、無効である' do
      user = build(:user, name: "a" * 21)
      expect(user).to be_invalid
    end

    it 'nameが20文字以下の場合、有効である' do
      user = build(:user, name: "a" * 20)
      expect(user).to be_valid
    end
  end
end
