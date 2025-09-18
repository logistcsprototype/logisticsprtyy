class DriversController < ApplicationController
  before_action :set_driver, only: [:show, :edit, :update, :destroy]

  # GET /drivers
  def index
    @drivers = Driver.includes(:license_type, :admin, :vehicles).all
    
    # Filtering
    @drivers = @drivers.where(license_type_id: params[:license_type_id]) if params[:license_type_id].present?
    @drivers = @drivers.where(admin_id: params[:admin_id]) if params[:admin_id].present?
    @drivers = @drivers.where(gender: params[:gender]) if params[:gender].present?
    
    # Search
    @drivers = @drivers.where('name ILIKE ?', "%#{params[:search]}%") if params[:search].present?
    
    @drivers = @drivers.order(created_at: :desc)
  end

  # GET /drivers/1
  def show
    @driver_work_logs = @driver.driver_work_logs.order(date: :desc)
    @performance_reports = @driver.driver_performances_reports.order(report_date: :desc)
    @assigned_vehicles = @driver.vehicles
  end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  def create
    @driver = Driver.new(driver_params)

    if @driver.save
      redirect_to @driver, notice: 'Driver was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /drivers/1
  def update
    if @driver.update(driver_params)
      redirect_to @driver, notice: 'Driver was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /drivers/1
  def destroy
    @driver.destroy
    redirect_to drivers_url, notice: 'Driver was successfully destroyed.'
  end

  # GET /drivers/1/assign_vehicle
  def assign_vehicle
    @driver = Driver.find(params[:id])
    @available_vehicles = Vehicle.where.not(id: @driver.vehicle_ids)
  end

  # POST /drivers/1/assign_vehicle
  def create_vehicle_assignment
    @driver = Driver.find(params[:id])
    vehicle = Vehicle.find(params[:vehicle_id])
    
    if @driver.vehicles << vehicle
      redirect_to @driver, notice: 'Vehicle assigned successfully.'
    else
      redirect_to assign_vehicle_driver_path(@driver), alert: 'Failed to assign vehicle.'
    end
  end

  # DELETE /drivers/1/remove_vehicle/1
  def remove_vehicle
    @driver = Driver.find(params[:id])
    vehicle = Vehicle.find(params[:vehicle_id])
    
    if @driver.vehicles.delete(vehicle)
      redirect_to @driver, notice: 'Vehicle removed successfully.'
    else
      redirect_to @driver, alert: 'Failed to remove vehicle.'
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
      :email,
      :address,
      :hire_date,
      :status
    )
  end
end