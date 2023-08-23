FactoryBot.define do
  factory :application do
    association :team
    name { "MyString" }
  end
end
