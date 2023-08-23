FactoryBot.define do
  factory :developer do
    association :team
    name { "MyString" }
  end
end
