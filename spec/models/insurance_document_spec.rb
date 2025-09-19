require 'rails_helper'

RSpec.describe InsuranceDocument, type: :model do
  # Associations
  it { should belong_to(:vehicle) }
  it { should belong_to(:admin) }

  # Validations
  it { should validate_presence_of(:vehicle_id) }
  it { should validate_presence_of(:admin_id) }
  it { should validate_presence_of(:document_type) }
  it { should validate_presence_of(:expiry_date) }

  # Optional: Factory validity
  it 'has a valid factory' do
    expect(build(:insurance_document)).to be_valid
  end

  # Custom logic
  describe 'expiry_date' do
    it 'is invalid if expiry_date is in the past' do
      document = build(:insurance_document, expiry_date: Date.yesterday)
      expect(document).to be_invalid
    end

    it 'is valid if expiry_date is today or in the future' do
      document = build(:insurance_document, expiry_date: Date.today)
      expect(document).to be_valid
    end
  end
end
