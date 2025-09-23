require 'rails_helper'

RSpec.describe "Vehicles API", type: :request do
  let(:admin)        { create(:admin) }
  let(:license_type) { create(:license_type) }
  let!(:vehicle) do
    create(:vehicle,
            admin: admin,
            license_type: license_type,
            plate_number: "ABC123",
            vehicle_type: "Truck",
            owner_type: "self",
            owner_name: "Fleet Corp")
  end

  let(:headers) { { 'Authorization' => "Bearer #{generate_jwt_token(admin)}" } }

  def generate_jwt_token(admin)
    Warden::JWTAuth::UserEncoder.new.call(admin, :admin, nil).first
  end

  describe "GET /vehicles" do
    it "returns a list of vehicles" do
      create_list(:vehicle, 2, admin: admin, license_type: license_type)
      get "/vehicles", headers: headers
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.first).to include("plate_number", "vehicle_type")
    end

    it "filters by admin_id" do
      get "/vehicles", params: { admin_id: admin.id }, headers: headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.first["admin_id"]).to eq(admin.id)
    end
  end

  describe "GET /vehicles/:id" do
    it "shows a single vehicle" do
      get "/vehicles/#{vehicle.id}", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(vehicle.id)
      expect(json["plate_number"]).to eq("ABC123")
    end
  end

  describe "POST /vehicles" do
    let(:valid_params) do
      {
        vehicle: {
          plate_number: "XYZ789",
          vehicle_type: "Van",
          capacity: 10,
          owner_type: "self",
          owner_name: "Main Owner",
          license_type_id: license_type.id,
          admin_id: admin.id
        }
      }
    end

    it "creates a new vehicle" do
      expect {
        post "/vehicles", params: valid_params, headers: headers
      }.to change(Vehicle, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["plate_number"]).to eq("XYZ789")
    end

    it "returns errors with invalid data" do
      post "/vehicles", params: { vehicle: { plate_number: "" } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include(/Plate number can't be blank/)
    end
  end

  describe "PATCH /vehicles/:id" do
    it "updates the vehicle" do
      patch "/vehicles/#{vehicle.id}", params: { vehicle: { vehicle_type: "SUV" } }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(vehicle.reload.vehicle_type).to eq("SUV")
    end

    it "returns errors with invalid update" do
      patch "/vehicles/#{vehicle.id}", params: { vehicle: { plate_number: "" } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include(/Plate number can't be blank/)
    end
  end

  describe "DELETE /vehicles/:id" do
    it "destroys the vehicle" do
      expect {
        delete "/vehicles/#{vehicle.id}", headers: headers
      }.to change(Vehicle, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
