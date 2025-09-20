require 'rails_helper'

RSpec.describe "LicenseTypes API", type: :request do
  let!(:license_type) { create(:license_type, code: "A1") }

  describe "GET /license_types" do
    it "returns a paginated list of license types" do
      create_list(:license_type, 3)
      get "/license_types", params: { limit: 2 }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.count).to be <= 2
      expect(body.first).to include("code")
    end
  end

  describe "GET /license_types/:id" do
    it "returns a single license type" do
      get "/license_types/#{license_type.id}"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["id"]).to eq(license_type.id)
      expect(body["code"]).to eq("A1")
    end
  end

  describe "POST /license_types" do
    let(:valid_params) { { license_type: { code: "B2" } } }

    it "creates a new license type" do
      expect {
        post "/license_types", params: valid_params
      }.to change(LicenseType, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["code"]).to eq("B2")
    end

    it "returns errors with invalid data" do
      post "/license_types", params: { license_type: { code: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include(/Code can't be blank/)
    end
  end

  describe "PATCH /license_types/:id" do
    it "updates the license type" do
      patch "/license_types/#{license_type.id}", params: { license_type: { code: "C3" } }

      expect(response).to have_http_status(:ok)
      expect(license_type.reload.code).to eq("C3")
    end

    it "returns errors when update fails" do
      patch "/license_types/#{license_type.id}", params: { license_type: { code: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include(/Code can't be blank/)
    end
  end

  describe "DELETE /license_types/:id" do
    it "deletes the license type" do
      expect {
        delete "/license_types/#{license_type.id}"
      }.to change(LicenseType, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
