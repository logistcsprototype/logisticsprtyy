FactoryBot.define do
  factory :driver_assignment do
    association :driver
    association :vehicle
    association :admin   
    assignment_status { "active" }     
    date_assigned { Faker::Date.backward(days: 10) }
    notes         { Faker::Lorem.sentence }
    
  end
end
