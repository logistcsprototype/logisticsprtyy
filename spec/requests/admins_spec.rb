# spec/requests/admins_spec.rb
require 'rails_helper'

RSpec.describe "Admins API", type: :request do
  let!(:admins) { create_list(:admin, 3) }
  let(:admin)   { admins.first }

  describe "GET /admins" do
    it "returns a list of admins with status 200" do
      get "/admins"
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body.length).to eq(3)
      expect(body.first).to include("name", "email")
    end
  end

  describe "GET /admins/:id" do
    it "returns a specific admin" do
      get "/admins/#{admin.id}"
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body["id"]).to eq(admin.id)
      expect(body["email"]).to eq(admin.email)
    end
  end

  describe "POST /admins" do
    let(:valid_params) do
      {
        admin: {
          name: "New Admin",
          email: "newadmin@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    it "creates a new admin with valid params" do
      expect {
        post "/admins", params: valid_params
      }.to change(Admin, :count).by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["name"]).to eq("New Admin")
    end

    it "returns errors with invalid params" do
      post "/admins", params: { admin: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body["errors"]).to be_present
    end
  end

  describe "PATCH /admins/:id" do
    it "updates an admin with valid data" do
      patch "/admins/#{admin.id}", params: { admin: { name: "Updated" } }
      expect(response).to have_http_status(:ok)
      expect(admin.reload.name).to eq("Updated")
    end

    it "returns errors with invalid data" do
      patch "/admins/#{admin.id}", params: { admin: { email: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "DELETE /admins/:id" do
    it "deletes the admin" do
      expect {
        delete "/admins/#{admin.id}"
      }.to change(Admin, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
