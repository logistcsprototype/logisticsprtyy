class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[show update destroy]

  # GET /vehicles
  def index
    vehicles = Vehicle.includes(:license_type, :admin, :driver_assignments, :maintenance_records, :insurance_documents)

    # Filtering
    vehicles = vehicles.where(license_type_id: params[:license_type_id]) if params[:license_type_id].present?
    vehicles = vehicles.where(admin_id: params[:admin_id]) if params[:admin_id].present?
    vehicles = vehicles.where(vehicle_type: params[:vehicle_type]) if params[:vehicle_type].present?
    vehicles = vehicles.where(owner_type: params[:owner_type]) if params[:owner_type].present?

    # Sorting
    sort_by = params[:sort_by] || 'created_at'
    sort_direction = params[:sort_direction] || 'desc'
    vehicles = vehicles.order("#{sort_by} #{sort_direction}")

    vehicles = vehicles.page(params[:page] || 1).per(params[:per_page] || 20)
    render json: vehicles, each_serializer: VehicleSerializer, meta: pagination_meta(vehicles), status: :ok
  end

  # GET /vehicles/:id
  def show
    render json: @vehicle, serializer: VehicleSerializer, status: :ok
  end

  # POST /vehicles
  def create
    vehicle = Vehicle.new(vehicle_params)
    if vehicle.save
      render json: vehicle, serializer: VehicleSerializer, status: :created
    else
      render json: { errors: vehicle.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vehicles/:id
  def update
    if @vehicle.update(vehicle_params)
      render json: @vehicle, serializer: VehicleSerializer, status: :ok
    else
      render json: { errors: @vehicle.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /vehicles/:id
  def destroy
    @vehicle.destroy
    head :no_content
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def vehicle_params
    params.require(:vehicle).permit(
      :plate_number,
      :vehicle_type,
      :capacity,
      :passenger_capacity,
      :weight_capacity,
      :license_type_id,
      :admin_id,
      :make,
      :model,
      :year,
      :color,
      :vin,
      :status
    )
  end
end
