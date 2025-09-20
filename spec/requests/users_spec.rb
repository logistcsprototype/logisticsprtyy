require 'rails_helper'

RSpec.describe "Users API", type: :request do
  let!(:user) { create(:user) }

  describe "GET /users" do
    it "returns all users" do
      get "/users"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first["email"]).to eq(user.email)
    end

    it "filters by role" do
      get "/users", params: { role: user.role }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).all? { |u| u["role"] == user.role }).to be true
    end
  end

  describe "GET /users/:id" do
    it "returns a user" do
      get "/users/#{user.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(user.id)
    end
  end

  describe "POST /users" do
    let(:valid_params) do
      {
        user: {
          name: "John Doe",
          email: "john@example.com",
          role: "driver",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    it "creates a new user" do
      expect {
        post "/users", params: valid_params
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid data" do
      post "/users", params: { user: { email: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "PATCH /users/:id" do
    it "updates a user" do
      patch "/users/#{user.id}", params: { user: { name: "Updated Name" } }
      expect(response).to have_http_status(:ok)
      expect(user.reload.name).to eq("Updated Name")
    end
  end

  describe "DELETE /users/:id" do
    it "deletes a user" do
      expect {
        delete "/users/#{user.id}"
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
