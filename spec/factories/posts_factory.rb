FactoryBot.define do
  factory :post, class: Post do
    title { Faker::Book.title }
    body { Faker::GameOfThrones.quote }
    association :author, factory: :author
  end
end
