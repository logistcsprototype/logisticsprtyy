FactoryBot.define do
  factory :vehicle do
    plate_number { Faker::Vehicle.unique.license_plate }
    vehicle_type { %w[Truck Van Car Bus].sample }
    capacity     { rand(1000..5000) }
    owner_type   { %w[Self ThirdParty].sample }
    owner_name   { Faker::Name.name }

    association :license_type
    association :admins
  end
end
