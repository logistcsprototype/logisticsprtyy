class MaintenancesController < ApplicationController
  before_action :set_maintenance, only: %i[show update destroy]

  # GET /maintenances
  def index
    maintenances = Maintenance.includes(:vehicle, :admin)

    # Filtering
    maintenances = maintenances.where(vehicle_id: params[:vehicle_id]) if params[:vehicle_id].present?
    maintenances = maintenances.where(admin_id: params[:admin_id]) if params[:admin_id].present?
    maintenances = maintenances.where(maintenance_type: params[:maintenance_type]) if params[:maintenance_type].present?

    maintenances = maintenances.limit(params[:limit] || 20).offset(params[:offset] || 0)
    render json: maintenances, status: :ok
  end

  # GET /maintenances/:id
  def show
    render json: @maintenance, status: :ok
  end

  # POST /maintenances
  def create
    maintenance = Maintenance.new(maintenance_params)
    if maintenance.save
      render json: maintenance, status: :created
    else
      render json: { errors: maintenance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /maintenances/:id
  def update
    if @maintenance.update(maintenance_params)
      render json: @maintenance, status: :ok
    else
      render json: { errors: @maintenance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /maintenances/:id
  def destroy
    @maintenance.destroy
    head :no_content
  end

  private

  def set_maintenance
    @maintenance = Maintenance.find(params[:id])
  end

  def maintenance_params
    params.require(:maintenance).permit(
      :vehicle_id,
      :admin_id,
      :maintenance_date,
      :description,
      :maintenance_type,
      :next_due_date,
      :mileage_at_service,
      :cost,
      :service_provider
    )
  end
end
