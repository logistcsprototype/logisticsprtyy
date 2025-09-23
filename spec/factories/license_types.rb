FactoryBot.define do
  factory :license_type do
    code        { %w[Special Private Commercial Motorcycle].sample }
    description { Faker::Vehicle.transmission.capitalize + " vehicle license" }
    
  end
end
