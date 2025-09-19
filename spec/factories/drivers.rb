FactoryBot.define do
  factory :driver do
    name            { Faker::Name.name }
    license_number  { Faker::Number.unique.number(digits: 8).to_s }
    address         { Faker::Address.full_address }
    years_experience { rand(1..20) }
    age             { rand(18..60) }
    gender          { %w[Male Female].sample }

    association :license_type
    association :admin
    
  end
end
