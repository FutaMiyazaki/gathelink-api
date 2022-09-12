FactoryBot.define do
  factory :link do
    association :user
    url { "https://gathelink.app" }
    title { "gathelinkのurlです" }
  end
end
