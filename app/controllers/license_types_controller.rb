class LicenseTypesController < ApplicationController
  before_action :set_license_type, only: %i[show update destroy]

  # GET /license_types
  def index
    license_types = LicenseType.includes(:drivers, :vehicles)
    license_types = license_types.limit(params[:limit] || 20).offset(params[:offset] || 0)
    render json: license_types, status: :ok
  end

  # GET /license_types/:id
  def show
    render json: @license_type, status: :ok
  end

  # POST /license_types
  def create
    license_type = LicenseType.new(license_type_params)
    if license_type.save
      render json: license_type, status: :created
    else
      render json: { errors: license_type.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /license_types/:id
  def update
    if @license_type.update(license_type_params)
      render json: @license_type, status: :ok
    else
      render json: { errors: @license_type.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /license_types/:id
  def destroy
    @license_type.destroy
    head :no_content
  end

  private

  def set_license_type
    @license_type = LicenseType.find(params[:id])
  end

  def license_type_params
    params.require(:license_type).permit(:code)
  end
end
