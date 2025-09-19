require 'rails_helper'

RSpec.describe LicenseType, type: :model do
  # Associations
  it { should have_many(:drivers) }
  it { should have_many(:vehicles) }

  # Validations
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code).case_insensitive }

  # Optional: Factory validity
  it 'has a valid factory' do
    expect(build(:license_type)).to be_valid
  end
end
