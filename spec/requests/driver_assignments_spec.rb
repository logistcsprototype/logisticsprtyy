# spec/requests/driver_assignments_spec.rb
require 'rails_helper'

RSpec.describe "DriverAssignments API", type: :request do
  let!(:admin)   { create(:admin) }
  let!(:license) { create(:license_type) }
  let!(:driver)  { create(:driver, admin: admin, license_type: license) }
  let!(:vehicle) { create(:vehicle, admin: admin, license_type: license) }
  let!(:assignments) { create_list(:driver_assignment, 3, admin: admin, driver: driver, vehicle: vehicle) }
  let(:assignment)   { assignments.first }

  describe "GET /driver_assignments" do
    it "returns a paginated list of assignments" do
      get "/driver_assignments"
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body.length).to eq(3)
      expect(body.first).to include("driver_id", "vehicle_id", "admin_id")
    end
  end

  describe "GET /driver_assignments/:id" do
    it "returns a single assignment" do
      get "/driver_assignments/#{assignment.id}"
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body["id"]).to eq(assignment.id)
      expect(body["driver_id"]).to eq(driver.id)
      expect(body["vehicle_id"]).to eq(vehicle.id)
    end
  end

  describe "POST /driver_assignments" do
    let(:valid_params) do
      {
        driver_assignment: {
          driver_id: driver.id,
          vehicle_id: vehicle.id,
          admin_id: admin.id,
          date_assigned: Date.today,
          vehicle_condition: "Good",
          end_date: Date.tomorrow,
          assignment_status: "active"
        }
      }
    end

    it "creates a new assignment with valid data" do
      expect {
        post "/driver_assignments", params: valid_params
      }.to change(DriverAssignment, :count).by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["driver_id"]).to eq(driver.id)
    end

    it "returns errors when invalid" do
      post "/driver_assignments", params: { driver_assignment: { driver_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "PATCH /driver_assignments/:id" do
    it "updates an assignment" do
      patch "/driver_assignments/#{assignment.id}",
            params: { driver_assignment: { vehicle_condition: "Needs service" } }

      expect(response).to have_http_status(:ok)
      expect(assignment.reload.vehicle_condition).to eq("Needs service")
    end

    it "returns errors on invalid update" do
      patch "/driver_assignments/#{assignment.id}",
            params: { driver_assignment: { driver_id: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "DELETE /driver_assignments/:id" do
    it "destroys the assignment" do
      expect {
        delete "/driver_assignments/#{assignment.id}"
      }.to change(DriverAssignment, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
