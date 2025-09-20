require 'rails_helper'

RSpec.describe "Drivers API", type: :request do
  let!(:admin)   { create(:admin) }
  let!(:license) { create(:license_type) }
  let!(:driver)  { create(:driver, admin: admin, license_type: license) }
  let!(:vehicle) { create(:vehicle, admin: admin, license_type: license) }

  describe "GET /drivers" do
    it "returns a list of drivers with filtering & pagination" do
      create_list(:driver, 2, admin: admin, license_type: license)
      get "/drivers", params: { limit: 2 }
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body.count).to be <= 2
      expect(body.first).to include("name", "license_number")
    end

    it "filters by gender" do
      male_driver = create(:driver, gender: "male", admin: admin, license_type: license)
      get "/drivers", params: { gender: "male" }
      ids = JSON.parse(response.body).map { |d| d["id"] }
      expect(ids).to include(male_driver.id)
    end
  end

  describe "GET /drivers/:id" do
    it "returns detailed driver info" do
      get "/drivers/#{driver.id}"
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body["driver"]["id"]).to eq(driver.id)
      expect(body["work_logs"]).to be_an(Array)
      expect(body["assigned_vehicles"]).to be_an(Array)
    end
  end

  describe "POST /drivers" do
    let(:valid_params) do
      {
        driver: {
          name: "John Doe",
          license_number: "ABC123",
          license_type_id: license.id,
          admin_id: admin.id,
          age: 35,
          gender: "male",
          contact_number: "555-1234",
          email: "john@example.com",
          address: "123 Main St",
          hire_date: Date.today,
          status: "active",
          years_experience: 5
        }
      }
    end

    it "creates a new driver with valid data" do
      expect {
        post "/drivers", params: valid_params
      }.to change(Driver, :count).by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["name"]).to eq("John Doe")
    end

    it "returns errors with invalid data" do
      post "/drivers", params: { driver: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "PATCH /drivers/:id" do
    it "updates an existing driver" do
      patch "/drivers/#{driver.id}", params: { driver: { age: 40 } }
      expect(response).to have_http_status(:ok)
      expect(driver.reload.age).to eq(40)
    end

    it "returns errors when update fails" do
      patch "/drivers/#{driver.id}", params: { driver: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "DELETE /drivers/:id" do
    it "deletes the driver" do
      delete "/drivers/#{driver.id}"
      expect(response).to have_http_status(:no_content)
      expect { driver.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "POST /drivers/:id/assign_vehicle" do
    it "assigns a vehicle to the driver" do
      post "/drivers/#{driver.id}/assign_vehicle",
           params: { vehicle_id: vehicle.id }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["driver"]["id"]).to eq(driver.id)
      expect(driver.vehicles.reload).to include(vehicle)
    end
  end

  describe "DELETE /drivers/:id/remove_vehicle/:vehicle_id" do
    before { driver.vehicles << vehicle }

    it "removes the vehicle from the driver" do
      delete "/drivers/#{driver.id}/remove_vehicle/#{vehicle.id}"

      expect(response).to have_http_status(:ok)
      expect(driver.vehicles.reload).not_to include(vehicle)
    end
  end
end
