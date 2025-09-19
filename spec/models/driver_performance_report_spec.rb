require 'rails_helper'

RSpec.describe DriverPerformanceReport, type: :model do
  # Associations
  it { should belong_to(:driver) }
  it { should belong_to(:vehicle) }
  it { should belong_to(:admin) }
  it { should belong_to(:reported_by).class_name('Admin').optional }

  # Validations
  it { should validate_presence_of(:driver_id) }
  it { should validate_presence_of(:vehicle_id) }
  it { should validate_presence_of(:admin_id) }
  it { should validate_presence_of(:report_date) }
  it { should validate_presence_of(:rating) }

  # Optional: Factory validity
  it 'has a valid factory' do
    expect(build(:driver_performance_report)).to be_valid
  end

  # Example: Custom logic (optional)
  describe 'rating range' do
    it 'is invalid if rating is less than 1' do
      report = build(:driver_performance_report, rating: 0)
      expect(report).to be_invalid
    end

    it 'is invalid if rating is greater than 5' do
      report = build(:driver_performance_report, rating: 6)
      expect(report).to be_invalid
    end
  end
end
