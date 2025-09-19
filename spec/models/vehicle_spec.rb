require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  # Associations
  it { should belong_to(:license_type) }
  it { should belong_to(:admin) }
  it { should have_many(:driver_assignments) }
  it { should have_many(:drivers).through(:driver_assignments) }
  it { should have_many(:maintenance_records).class_name('Maintenance') }
  it { should have_many(:insurance_documents) }

  # Validations
  it { should validate_presence_of(:plate_number) }
  it { should validate_uniqueness_of(:plate_number).case_insensitive }
  it { should validate_presence_of(:vehicle_type) }
  it { should validate_numericality_of(:passenger_capacity).is_greater_than_or_equal_to(1).allow_nil }
  it { should validate_numericality_of(:weight_capacity).is_greater_than(0).allow_nil }
  it { should validate_presence_of(:owner_type) }
  it { should validate_inclusion_of(:owner_type).in_array(%w[self third_party]) }
  it { should validate_presence_of(:owner_name) }

  # Optional: Factory validity
  it 'has a valid factory' do
    expect(build(:vehicle)).to be_valid
  end
end
