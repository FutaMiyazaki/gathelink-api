FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "testuser_#{n}" }
    sequence(:email) { |n| "test+#{n}@gathelink.app" }
    password { "password" }
  end
end
