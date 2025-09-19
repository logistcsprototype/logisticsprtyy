FactoryBot.define do
  factory :driver_work_log do
    association :driver
    association :vehicle
    association :admin

    date       { Faker::Date.backward(days: 30) }
    start_time { Faker::Time.backward(days: 1, period: :morning) }
    end_time   { start_time + rand(1..8).hours }
    total_hours { ((end_time - start_time) / 1.hour).round(2) }
    
  end
end
