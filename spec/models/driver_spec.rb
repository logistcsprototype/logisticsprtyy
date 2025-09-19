require 'rails_helper'

RSpec.describe Driver, type: :model do
  # Associations
  it { should belong_to(:license_type) }
  it { should belong_to(:admin) }
  it { should have_many(:driver_assignments) }
  it { should have_many(:vehicles).through(:driver_assignments) }
  it { should have_many(:driver_work_logs) }
  it { should have_many(:driver_performances_reports) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:license_number) }
  it { should validate_uniqueness_of(:license_number).case_insensitive }
  it { should validate_presence_of(:license_type_id) }
  it { should validate_presence_of(:admin_id) }
  it { should validate_presence_of(:age) }
  it { should validate_presence_of(:gender) }

  # Optional: Factory validity
  it 'has a valid factory' do
    expect(build(:driver)).to be_valid
  end

  # Custom validations / logic examples
  describe 'years_experience' do
    it 'is invalid if negative' do
      driver = build(:driver, years_experience: -1)
      expect(driver).to be_invalid
    end

    it 'is valid for 0 or positive values' do
      driver = build(:driver, years_experience: 0)
      expect(driver).to be_valid
    end
  end
end
