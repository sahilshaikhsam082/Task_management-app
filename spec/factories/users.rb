# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password123' }
    password_digest { BCrypt::Password.create('password123') }

    trait :admin do
      role { :admin }
    end

    trait :member do
      role { :member }
    end
  end
end
