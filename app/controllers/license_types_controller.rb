class LicenseTypesController < ApplicationController
  before_action :set_license_type, only: [:show, :edit, :update, :destroy]

  def index
    @license_types = LicenseType.all
  end

  def show
  end

  def new
    @license_type = LicenseType.new
  end

  def create
    @license_type = LicenseType.new(license_type_params)
    if @license_type.save
      redirect_to @license_type, notice: 'License type was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @license_type.update(license_type_params)
      redirect_to @license_type, notice: 'License type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @license_type.destroy
    redirect_to license_types_url, notice: 'License type was successfully destroyed.'
  end

  private

  def set_license_type
    @license_type = LicenseType.find(params[:id])
  end

  def license_type_params
    params.require(:license_type).permit(:code)
  end
end
