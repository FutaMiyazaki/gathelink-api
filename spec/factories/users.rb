FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:name) { |n| "testuser_#{n}" }
    sequence(:email) { |n| "test+#{n}@gathelink.app" }
    password { "password" }

    trait :with_folders do
      after(:build) do |user|
        user.folders << build(:folder, name: "テストユーザのフォルダ")
      end
    end
  end
end
