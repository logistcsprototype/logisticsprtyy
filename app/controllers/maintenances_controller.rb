class MaintenancesController < ApplicationController
  before_action :set_maintenance, only: [:show, :edit, :update, :destroy]

  def index
    @maintenances = Maintenance.all
  end

  def show
  end

  def new
    @maintenance = Maintenance.new
  end

  def create
    @maintenance = Maintenance.new(maintenance_params)
    if @maintenance.save
      redirect_to @maintenance, notice: 'Maintenance record was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @maintenance.update(maintenance_params)
      redirect_to @maintenance, notice: 'Maintenance record was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @maintenance.destroy
    redirect_to maintenances_url, notice: 'Maintenance record was successfully destroyed.'
  end

  private

  def set_maintenance
    @maintenance = Maintenance.find(params[:id])
  end

  def maintenance_params
    params.require(:maintenance).permit(
      :vehicle_id, :admin_id, :maintenance_date, :description
    )
  end
end
