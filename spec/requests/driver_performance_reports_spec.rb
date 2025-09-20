# spec/requests/driver_performance_reports_spec.rb
require 'rails_helper'

RSpec.describe "DriverPerformanceReports API", type: :request do
  let!(:admin)   { create(:admin) }
  let!(:license) { create(:license_type) }
  let!(:driver)  { create(:driver, admin: admin, license_type: license) }
  let!(:vehicle) { create(:vehicle, admin: admin, license_type: license) }
  let!(:reporter){ create(:admin) } # assuming reported_by is also an Admin
  let!(:reports) { create_list(:driver_performance_report, 3,
                               admin: admin,
                               driver: driver,
                               vehicle: vehicle,
                               reported_by: reporter) }
  let(:report)   { reports.first }

  describe "GET /driver_performance_reports" do
    it "returns a paginated list of reports" do
      get "/driver_performance_reports"
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body.length).to eq(3)
      expect(body.first).to include("driver_id", "admin_id", "vehicle_id", "rating")
    end
  end

  describe "GET /driver_performance_reports/:id" do
    it "returns a single report" do
      get "/driver_performance_reports/#{report.id}"
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body["id"]).to eq(report.id)
      expect(body["driver_id"]).to eq(driver.id)
      expect(body["vehicle_id"]).to eq(vehicle.id)
    end
  end

  describe "POST /driver_performance_reports" do
    let(:valid_params) do
      {
        driver_performance_report: {
          driver_id: driver.id,
          admin_id: admin.id,
          vehicle_id: vehicle.id,
          report_date: Date.today,
          rating: 4,
          comments: "Great performance",
          performance_metrics: "On-time deliveries",
          reported_by_id: reporter.id
        }
      }
    end

    it "creates a report with valid data" do
      expect {
        post "/driver_performance_reports", params: valid_params
      }.to change(DriverPerformanceReport, :count).by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["driver_id"]).to eq(driver.id)
      expect(body["rating"]).to eq(4)
    end

    it "returns errors with invalid data" do
      post "/driver_performance_reports",
           params: { driver_performance_report: { driver_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "PATCH /driver_performance_reports/:id" do
    it "updates the report successfully" do
      patch "/driver_performance_reports/#{report.id}",
            params: { driver_performance_report: { rating: 5 } }

      expect(response).to have_http_status(:ok)
      expect(report.reload.rating).to eq(5)
    end

    it "returns errors on invalid update" do
      patch "/driver_performance_reports/#{report.id}",
            params: { driver_performance_report: { driver_id: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "DELETE /driver_performance_reports/:id" do
    it "destroys the report" do
      expect {
        delete "/driver_performance_reports/#{report.id}"
      }.to change(DriverPerformanceReport, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
