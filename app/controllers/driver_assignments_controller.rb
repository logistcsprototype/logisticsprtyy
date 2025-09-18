class DriverAssignmentsController < ApplicationController
  before_action :set_driver_assignment, only: [:show, :edit, :update, :destroy]

  def index
    @driver_assignments = DriverAssignment.all
  end

  def show
  end

  def new
    @driver_assignment = DriverAssignment.new
  end

  def create
    @driver_assignment = DriverAssignment.new(driver_assignment_params)
    if @driver_assignment.save
      redirect_to @driver_assignment, notice: 'Driver assignment was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @driver_assignment.update(driver_assignment_params)
      redirect_to @driver_assignment, notice: 'Driver assignment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @driver_assignment.destroy
    redirect_to driver_assignments_url, notice: 'Driver assignment was successfully destroyed.'
  end

  private

  def set_driver_assignment
    @driver_assignment = DriverAssignment.find(params[:id])
  end

  def driver_assignment_params
    params.require(:driver_assignment).permit(
      :driver_id, :vehicle_id, :admin_id, :date_assigned, :vehicle_condition
    )
  end
end
