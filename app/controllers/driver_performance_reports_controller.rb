class DriverPerformanceReportsController < ApplicationController
  before_action :set_driver_performance_report, only: %i[show update destroy]

  # GET /driver_performance_reports
  def index
    reports = DriverPerformanceReport.includes(:driver, :admin, :vehicle, :reported_by)
    reports = reports.limit(params[:limit] || 20).offset(params[:offset] || 0)
    render json: reports, status: :ok
  end

  # GET /driver_performance_reports/:id
  def show
    render json: @driver_performance_report, status: :ok
  end

  # POST /driver_performance_reports
  def create
    report = DriverPerformanceReport.new(driver_performance_report_params)
    if report.save
      render json: report, status: :created
    else
      render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /driver_performance_reports/:id
  def update
    if @driver_performance_report.update(driver_performance_report_params)
      render json: @driver_performance_report, status: :ok
    else
      render json: { errors: @driver_performance_report.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /driver_performance_reports/:id
  def destroy
    @driver_performance_report.destroy
    head :no_content
  end

  private

  def set_driver_performance_report
    @driver_performance_report = DriverPerformanceReport.find(params[:id])
  end

  def driver_performance_report_params
    params.require(:driver_performance_report).permit(
      :driver_id,
      :admin_id,
      :vehicle_id,
      :report_date,
      :rating,
      :comments,
      :performance_metrics,
      :reported_by_id
    )
  end
end
