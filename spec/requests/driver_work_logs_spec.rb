require 'rails_helper'

RSpec.describe "DriverWorkLogs API", type: :request do
  let(:admin)   { create(:admin) }
  let(:driver)  { create(:driver, admin: admin) }
  let(:vehicle) { create(:vehicle, admin: admin, license_type: create(:license_type)) }

  let!(:log) do
    create(:driver_work_log,
           driver: driver,
           vehicle: vehicle,
           admin: admin,
           date: Date.today,
           start_time: Time.zone.now - 4.hours,
           end_time: Time.zone.now)
  end

  describe "GET /driver_work_logs" do
    it "returns all logs" do
      get "/driver_work_logs"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first).to include("driver_id", "vehicle_id", "admin_id")
    end

    it "filters by driver_id" do
      get "/driver_work_logs", params: { driver_id: driver.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).all? { |h| h["driver_id"] == driver.id }).to be true
    end
  end

  describe "GET /driver_work_logs/:id" do
    it "shows a single log" do
      get "/driver_work_logs/#{log.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(log.id)
    end
  end

  describe "POST /driver_work_logs" do
    let(:valid_params) do
      {
        driver_work_log: {
          driver_id: driver.id,
          vehicle_id: vehicle.id,
          admin_id: admin.id,
          date: Date.today,
          start_time: 2.hours.ago,
          end_time: Time.current
        }
      }
    end

    it "creates a new log" do
      expect {
        post "/driver_work_logs", params: valid_params
      }.to change(DriverWorkLog, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid data" do
      post "/driver_work_logs", params: { driver_work_log: { driver_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "PATCH /driver_work_logs/:id" do
    it "updates the log" do
      patch "/driver_work_logs/#{log.id}", params: { driver_work_log: { date: Date.tomorrow } }
      expect(response).to have_http_status(:ok)
      expect(log.reload.date).to eq(Date.tomorrow)
    end
  end

  describe "DELETE /driver_work_logs/:id" do
    it "destroys the log" do
      expect {
        delete "/driver_work_logs/#{log.id}"
      }.to change(DriverWorkLog, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
