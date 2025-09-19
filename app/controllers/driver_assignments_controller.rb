class DriverAssignmentsController < ApplicationController
  before_action :set_driver_assignment, only: %i[show update destroy]

  # GET /driver_assignments
  def index
    assignments = DriverAssignment.includes(:driver, :vehicle, :admin)
    assignments = assignments.limit(params[:limit] || 20).offset(params[:offset] || 0)
    render json: assignments, status: :ok
  end

  # GET /driver_assignments/:id
  def show
    render json: @driver_assignment, status: :ok
  end

  # POST /driver_assignments
  def create
    assignment = DriverAssignment.new(driver_assignment_params)

    if assignment.save
      render json: assignment, status: :created
    else
      render json: { errors: assignment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /driver_assignments/:id
  def update
    if @driver_assignment.update(driver_assignment_params)
      render json: @driver_assignment, status: :ok
    else
      render json: { errors: @driver_assignment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /driver_assignments/:id
  def destroy
    @driver_assignment.destroy
    head :no_content
  end

  private

  def set_driver_assignment
    @driver_assignment = DriverAssignment.find(params[:id])
  end

  def driver_assignment_params
    params.require(:driver_assignment).permit(
      :driver_id,
      :vehicle_id,
      :admin_id,
      :date_assigned,
      :vehicle_condition,
      :end_date,
      :assignment_status
    )
  end
end
