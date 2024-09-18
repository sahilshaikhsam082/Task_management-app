# spec/factories/tasks.rb
FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    completed { false }
    association :created_by, factory: :user, role: :admin
  end
end
