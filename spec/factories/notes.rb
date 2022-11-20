FactoryBot.define do
  factory :note do
    author { nil }
    content { "MyString" }
    to { "" }
  end
end
