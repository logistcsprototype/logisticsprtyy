require 'rails_helper'

RSpec.describe Maintenance, type: :model do
  # Associations
  it { should belong_to(:vehicle) }
  it { should belong_to(:admin) }

  # Validations
  it { should validate_presence_of(:maintenance_date) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:maintenance_type) }
  it { should validate_presence_of(:next_due_date) }
  it { should validate_numericality_of(:mileage_at_service).is_greater_than_or_equal_to(0).allow_nil }
  it { should validate_numericality_of(:cost).is_greater_than_or_equal_to(0).allow_nil }
  it { should validate_presence_of(:service_provider) }

  # Enums
  it { should define_enum_for(:maintenance_type).with_values(
    tires: 0, oil: 1, inspection: 2, brake: 3, battery: 4, engine: 5, transmission: 6, other: 7
  )}

  # Optional: Factory validity
  it 'has a valid factory' do
    expect(build(:maintenance)).to be_valid
  end
end
