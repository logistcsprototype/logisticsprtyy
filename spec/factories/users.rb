FactoryBot.define do
  factory :user do
    name  { Faker::Name.name }
    role  { %w[admin driver vehicleManager].sample }
    email { Faker::Internet.unique.email }
    password              { 'password123' }
    password_confirmation { 'password123' }
    
  end
end
