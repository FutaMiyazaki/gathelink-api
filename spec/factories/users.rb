FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:name) { |n| "testuser_#{n}" }
    sequence(:email) { |n| "test+#{n}@gathelink.app" }
    password { "password" }

    trait :with_folders do
      after(:build) do |user|
        user.folders << build(:folder, name: "テストユーザのフォルダ", description: "テストユーザのフォルダです")
      end
    end

    trait :with_favorite_folders do
      after(:build) do |user|
        user.favorite_folders << build(:folder_favorite)
      end
    end
  end
end
