require 'rails_helper'

RSpec.describe DriverAssignment, type: :model do
  # Associations
  it { should belong_to(:driver) }
  it { should belong_to(:vehicle) }
  it { should belong_to(:admin) }

  # Validations
  it { should validate_presence_of(:driver_id) }
  it { should validate_presence_of(:vehicle_id) }
  it { should validate_presence_of(:admin_id) }
  it { should validate_presence_of(:date_assigned) }

  # Optional: Factory validity
  it 'has a valid factory' do
    expect(build(:driver_assignment)).to be_valid
  end

  # Custom validation
  #describe 'custom validations' do
   # it 'ensures a driver can have only one active assignment at a time' do
    #  driver = create(:driver)
     # vehicle1 = create(:vehicle)
      #vehicle2 = create(:vehicle)
      #create(:driver_assignment, driver: driver, vehicle: vehicle1, assignment_status: 'active')
      #new_assignment = build(:driver_assignment, driver: driver, vehicle: vehicle2, assignment_status: 'active')
      #expect(new_assignment).to be_invalid
    #end
 #end
end
