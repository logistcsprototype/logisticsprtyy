require 'rails_helper'

RSpec.describe "Maintenances API", type: :request do
  let(:admin)    { create(:admin) }
  let(:vehicle)  { create(:vehicle, admin: admin) }
  let!(:maintenance) do
    create(:maintenance,
           vehicle: vehicle,
           admin: admin,
           maintenance_type: :oil,
           maintenance_date: Date.today,
           description: "Oil change",
           next_due_date: 1.month.from_now,
           service_provider: "QuickFix")
  end

  describe "GET /maintenances" do
    it "lists maintenances with default limit" do
      create_list(:maintenance, 3, vehicle: vehicle, admin: admin)
      get "/maintenances", params: { limit: 2 }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to be <= 2
      expect(json.first).to include("description", "maintenance_type")
    end

    it "filters by vehicle_id" do
      get "/maintenances", params: { vehicle_id: vehicle.id }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.first["vehicle_id"]).to eq(vehicle.id)
    end
  end

  describe "GET /maintenances/:id" do
    it "returns a single maintenance record" do
      get "/maintenances/#{maintenance.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(maintenance.id)
      expect(json["description"]).to eq("Oil change")
    end
  end

  describe "POST /maintenances" do
    let(:valid_params) do
      {
        maintenance: {
          vehicle_id: vehicle.id,
          admin_id: admin.id,
          maintenance_type: "brake",
          maintenance_date: Date.today,
          description: "Brake replacement",
          next_due_date: 1.month.from_now,
          mileage_at_service: 20000,
          cost: 150.0,
          service_provider: "BrakePro"
        }
      }
    end

    it "creates a maintenance record" do
      expect {
        post "/maintenances", params: valid_params
      }.to change(Maintenance, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["maintenance_type"]).to eq("brake")
    end

    it "returns errors with invalid data" do
      post "/maintenances", params: { maintenance: { vehicle_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include(/Vehicle must exist/)
    end
  end

  describe "PATCH /maintenances/:id" do
    it "updates a maintenance record" do
      patch "/maintenances/#{maintenance.id}", params: {
        maintenance: { description: "Updated oil change" }
      }

      expect(response).to have_http_status(:ok)
      expect(maintenance.reload.description).to eq("Updated oil change")
    end

    it "returns errors when invalid" do
      patch "/maintenances/#{maintenance.id}", params: {
        maintenance: { description: "" }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include(/Description can't be blank/)
    end
  end

  describe "DELETE /maintenances/:id" do
    it "removes the maintenance record" do
      expect {
        delete "/maintenances/#{maintenance.id}"
      }.to change(Maintenance, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
