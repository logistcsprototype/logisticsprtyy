class DriverWorkLogsController < ApplicationController
  before_action :set_driver_work_log, only: %i[show update destroy]

  # GET /driver_work_logs
  def index
    logs = DriverWorkLog.includes(:driver, :vehicle, :admin)

    # Optional filtering
    logs = logs.where(driver_id: params[:driver_id]) if params[:driver_id].present?
    logs = logs.where(vehicle_id: params[:vehicle_id]) if params[:vehicle_id].present?
    logs = logs.where(admin_id: params[:admin_id]) if params[:admin_id].present?

    # Pagination
    logs = logs.limit(params[:limit] || 20).offset(params[:offset] || 0)

    render json: logs, status: :ok
  end

  # GET /driver_work_logs/:id
  def show
    render json: @driver_work_log, status: :ok
  end

  # POST /driver_work_logs
  def create
    log = DriverWorkLog.new(driver_work_log_params)
    if log.save
      render json: log, status: :created
    else
      render json: { errors: log.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /driver_work_logs/:id
  def update
    if @driver_work_log.update(driver_work_log_params)
      render json: @driver_work_log, status: :ok
    else
      render json: { errors: @driver_work_log.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /driver_work_logs/:id
  def destroy
    @driver_work_log.destroy
    head :no_content
  end

  private

  def set_driver_work_log
    @driver_work_log = DriverWorkLog.find(params[:id])
  end

  def driver_work_log_params
    params.require(:driver_work_log).permit(
      :driver_id,
      :vehicle_id,
      :admin_id,
      :date,
      :start_time,
      :end_time,
      :total_hours # calculated automatically but permitted for completeness
    )
  end
end
