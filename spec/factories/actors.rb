FactoryBot.define do
  factory :actor do
    sequence(:username) { |i| "actor-#{i}" }
  end
end
