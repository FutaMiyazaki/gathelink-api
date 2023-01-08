FactoryBot.define do
  factory :folder do
    association :user
    name { "テストフォルダ" }
    description { "これはテスト用のフォルダです" }
    color { "#26a69a" }
    icon { "basketball" }
  end
end
