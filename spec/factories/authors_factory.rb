FactoryBot.define do
  factory :author, class: Author do
    name { Faker::Name.name }
    association :posts, factory: :post
  end
end
