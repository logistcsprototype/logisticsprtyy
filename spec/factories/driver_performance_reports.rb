FactoryBot.define do
  factory :driver_performance_report do
    association :driver
    association :admin
    association :vehicle

    report_date { Faker::Date.backward(days: 30) }
    rating      { rand(1..5) }
    comments    { Faker::Lorem.sentence(word_count: 12) }
  end
end
