require 'rails_helper'

RSpec.describe Admin, type: :model do
  # Associations
  it { should have_many(:vehicles) }
  it { should have_many(:drivers) }
  it { should have_many(:driver_assignments) }
  it { should have_many(:maintenance_records).class_name('Maintenance') }
  it { should have_many(:driver_performances_reports) }
  it { should have_many(:insurance_documents) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  # Password
  describe 'has_secure_password' do
    it 'is invalid without a password' do
      admin = Admin.new(name: 'Test', email: 'test@example.com')
      expect(admin).to be_invalid
      expect(admin.errors[:password]).to include("can't be blank")
    end

    it 'authenticates with correct password' do
      admin = create(:admin, password: 'password123')
      expect(admin.authenticate('password123')).to eq(admin)
    end

    it 'does not authenticate with wrong password' do
      admin = create(:admin, password: 'password123')
      expect(admin.authenticate('wrongpass')).to be_falsey
    end
  end

  # Optional: Factory validity
  it 'has a valid factory' do
    expect(build(:admin)).to be_valid
  end
end
