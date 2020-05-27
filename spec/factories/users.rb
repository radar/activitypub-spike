FactoryBot.define do
  factory :user do
    sequence(:username) { |i| "user-#{i}" }
  end
end
