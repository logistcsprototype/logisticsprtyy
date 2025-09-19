require 'rails_helper'

RSpec.describe User, type: :model do
  # Validations
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:role) }
  it { should validate_inclusion_of(:role).in_array(%w[admin driver vehicleManager]) }

  # Password
  describe 'has_secure_password' do
    it 'is invalid without a password' do
      user = User.new(name: 'Test User', email: 'test@example.com', role: 'admin')
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'authenticates with correct password' do
      user = create(:user, password: 'password123')
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with wrong password' do
      user = create(:user, password: 'password123')
      expect(user.authenticate('wrongpass')).to be_falsey
    end
  end

  # Optional: Factory validity
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end
end
