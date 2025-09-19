FactoryBot.define do
  factory :license_type do
    code        { %w[Special Class-C Class-D Class-M].sample }
    description { Faker::Vehicle.transmission.capitalize + " vehicle license" }
    
  end
end
