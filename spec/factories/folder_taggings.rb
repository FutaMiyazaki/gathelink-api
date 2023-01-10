FactoryBot.define do
  factory :folder_tagging do
    association :folder
    association :tag
  end
end
