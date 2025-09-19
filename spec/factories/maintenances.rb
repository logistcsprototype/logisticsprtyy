FactoryBot.define do
  factory :maintenance do
    association :vehicle
    association :admin

    maintenance_date { Faker::Date.backward(days: 30) }
    description      { Faker::Vehicle.standard_specs.join(', ') }
    cost             { Faker::Commerce.price(range: 50.0..500.0) }
    next_due_date    { maintenance_date + rand(30..180).days }
    
  end
end
