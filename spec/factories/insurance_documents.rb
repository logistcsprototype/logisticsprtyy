FactoryBot.define do
  factory :insurance_document do
    association :vehicle
    association :admin

    document_type { %w[Comprehensive ThirdParty Collision].sample }
    expiry_date   { Faker::Date.forward(days: 365) }
    document_url  { Faker::Internet.url(host: 'example.com', path: '/insurance.pdf') }
    notes         { Faker::Lorem.sentence(word_count: 10) }
    
  end
end
