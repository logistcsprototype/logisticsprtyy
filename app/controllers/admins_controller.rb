class AdminsController < ApplicationController
  before_action :set_admin, only: %i[show update destroy]

  # GET /admins
  def index
    admins = Admin.includes(:vehicles, :drivers, :driver_assignments, :maintenance_records, :driver_performances_reports, :insurance_documents)
    admins = admins.limit(params[:limit] || 20).offset(params[:offset] || 0)
    render json: admins, status: :ok
  end

  # GET /admins/:id
  def show
    render json: @admin, status: :ok
  end

  # POST /admins
  def create
    admin = Admin.new(admin_params)
    if admin.save
      render json: admin, status: :created
    else
      render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admins/:id
  def update
    if @admin.update(admin_params)
      render json: @admin, status: :ok
    else
      render json: { errors: @admin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /admins/:id
  def destroy
    @admin.destroy
    head :no_content
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:name, :email, :password, :password_confirmation)
  end
end
