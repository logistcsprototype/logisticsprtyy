class DriversController < ApplicationController
  before_action :set_driver, only: %i[
    show update destroy assign_vehicle create_vehicle_assignment remove_vehicle
  ]

  # GET /drivers
  def index
    drivers = Driver.includes(:license_type, :admin, :vehicles).order(created_at: :desc)

    # Filtering
    drivers = drivers.where(license_type_id: params[:license_type_id]) if params[:license_type_id].present?
    drivers = drivers.where(admin_id: params[:admin_id]) if params[:admin_id].present?
    drivers = drivers.where(gender: params[:gender]) if params[:gender].present?

    # Search
    drivers = drivers.where("LOWER(name) LIKE LOWER(?)", "%#{params[:search]}%") if params[:search].present?

    # Pagination
    drivers = drivers.limit(params[:limit] || 20).offset(params[:offset] || 0)

    render json: drivers, status: :ok
  end

  # GET /drivers/:id
  def show
    render json: {
      driver: @driver,
      work_logs: @driver.driver_work_logs.order(date: :desc),
      performance_reports: @driver.driver_performances_reports.order(report_date: :desc),
      assigned_vehicles: @driver.vehicles
    }, status: :ok
  end

  # POST /drivers
  def create
    driver = Driver.new(driver_params)
    if driver.save
      render json: driver, status: :created
    else
      render json: { errors: driver.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /drivers/:id
  def update
    if @driver.update(driver_params)
      render json: @driver, status: :ok
    else
      render json: { errors: @driver.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /drivers/:id
  def destroy
    @driver.destroy
    head :no_content
  end

  # POST /drivers/:id/assign_vehicle
  def create_vehicle_assignment
    vehicle = Vehicle.find(params[:vehicle_id])

    if @driver.vehicles << vehicle
      render json: { message: "Vehicle assigned successfully", driver: @driver }, status: :ok
    else
      render json: { errors: [ "Failed to assign vehicle" ] }, status: :unprocessable_entity
    end
  end

  # DELETE /drivers/:id/remove_vehicle/:vehicle_id
  def remove_vehicle
    vehicle = Vehicle.find(params[:vehicle_id])

    if @driver.vehicles.delete(vehicle)
      render json: { message: "Vehicle removed successfully", driver: @driver }, status: :ok
    else
      render json: { errors: [ "Failed to remove vehicle" ] }, status: :unprocessable_entity
    end
  end

  private

  def set_driver
    @driver = Driver.find(params[:id])
  end

  def driver_params
    params.require(:driver).permit(
      :name,
      :license_number,
      :license_type_id,
      :admin_id,
      :age,
      :gender,
      :contact_number,
      :emergency_contact,
      :email,
      :address,
      :hire_date,
      :status,
      :years_experience
    )
  end
end
