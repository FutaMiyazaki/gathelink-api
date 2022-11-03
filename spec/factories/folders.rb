FactoryBot.define do
  factory :folder do
    association :user
    name { "テストフォルダ" }
    description { "これはテスト用のフォルダです" }
  end
end
