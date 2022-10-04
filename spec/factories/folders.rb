FactoryBot.define do
  factory :folder do
    association :user
    name { "フォルダ名" }
  end
end
