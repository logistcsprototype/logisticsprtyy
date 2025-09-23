FactoryBot.define do
  factory :admin do
    name  { Faker::Name.name }
    email { Faker::Internet.unique.email }
    # role  { %w[admin driver ].sample }
    password              { 'password123' }
    password_confirmation { 'password123' }
  end
end
