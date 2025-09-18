class DriverPerformanceReportsController < ApplicationController
  before_action :set_driver_performance_report, only: [:show, :edit, :update, :destroy]

  def index
    @driver_performance_reports = DriverPerformanceReport.all
  end

  def show
  end

  def new
    @driver_performance_report = DriverPerformanceReport.new
  end

  def create
    @driver_performance_report = DriverPerformanceReport.new(driver_performance_report_params)
    if @driver_performance_report.save
      redirect_to @driver_performance_report, notice: 'Driver performance report was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @driver_performance_report.update(driver_performance_report_params)
      redirect_to @driver_performance_report, notice: 'Driver performance report was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @driver_performance_report.destroy
    redirect_to driver_performance_reports_url, notice: 'Driver performance report was successfully destroyed.'
  end

  private

  def set_driver_performance_report
    @driver_performance_report = DriverPerformanceReport.find(params[:id])
  end

  def driver_performance_report_params
    params.require(:driver_performance_report).permit(
      :driver_id, :admin_id, :vehicle_id, :report_date, :rating
    )
  end
end
