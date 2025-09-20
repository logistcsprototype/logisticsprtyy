require 'rails_helper'

RSpec.describe "InsuranceDocuments API", type: :request do
  let!(:admin)   { create(:admin) }
  let!(:license) { create(:license_type) }
  let!(:vehicle) { create(:vehicle, admin: admin, license_type: license) }
  let!(:document) do
    create(:insurance_document,
           vehicle: vehicle,
           admin: admin,
           document_type: "Liability",
           expiry_date: Date.today + 1.year)
  end

  describe "GET /insurance_documents" do
    it "returns a paginated list of insurance documents" do
      create_list(:insurance_document, 3, vehicle: vehicle, admin: admin)
      get "/insurance_documents", params: { limit: 2 }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.count).to be <= 2
      expect(body.first).to include("document_type", "expiry_date")
    end
  end

  describe "GET /insurance_documents/:id" do
    it "shows a single insurance document" do
      get "/insurance_documents/#{document.id}"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["id"]).to eq(document.id)
      expect(body["document_type"]).to eq("Liability")
    end
  end

  describe "POST /insurance_documents" do
    let(:valid_params) do
      {
        insurance_document: {
          vehicle_id: vehicle.id,
          admin_id: admin.id,
          document_type: "Collision",
          expiry_date: Date.today + 6.months
        }
      }
    end

    it "creates a new insurance document" do
      expect {
        post "/insurance_documents", params: valid_params
      }.to change(InsuranceDocument, :count).by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["document_type"]).to eq("Collision")
    end

    it "returns errors for invalid data" do
      post "/insurance_documents", params: { insurance_document: { vehicle_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "PATCH /insurance_documents/:id" do
    it "updates an existing insurance document" do
      patch "/insurance_documents/#{document.id}",
            params: { insurance_document: { document_type: "Comprehensive" } }

      expect(response).to have_http_status(:ok)
      expect(document.reload.document_type).to eq("Comprehensive")
    end

    it "returns errors when update fails" do
      patch "/insurance_documents/#{document.id}",
            params: { insurance_document: { document_type: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "DELETE /insurance_documents/:id" do
    it "deletes the insurance document" do
      expect {
        delete "/insurance_documents/#{document.id}"
      }.to change(InsuranceDocument, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
