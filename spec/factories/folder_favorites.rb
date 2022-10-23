FactoryBot.define do
  factory :folder_favorite do
    association :user
    association :folder
  end
end
