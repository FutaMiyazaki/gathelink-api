FactoryBot.define do
  factory :link do
    association :user
    association :folder
    url { "https://gathelink.app" }
    title { "gathelinkのurlです" }
  end
end
