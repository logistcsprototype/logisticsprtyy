class InsuranceDocumentsController < ApplicationController
  before_action :set_insurance_document, only: [:show, :edit, :update, :destroy]

  def index
    @insurance_documents = InsuranceDocument.all
  end

  def show
  end

  def new
    @insurance_document = InsuranceDocument.new
  end

  def create
    @insurance_document = InsuranceDocument.new(insurance_document_params)
    if @insurance_document.save
      redirect_to @insurance_document, notice: 'Insurance document was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @insurance_document.update(insurance_document_params)
      redirect_to @insurance_document, notice: 'Insurance document was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @insurance_document.destroy
    redirect_to insurance_documents_url, notice: 'Insurance document was successfully destroyed.'
  end

  private

  def set_insurance_document
    @insurance_document = InsuranceDocument.find(params[:id])
  end

  def insurance_document_params
    params.require(:insurance_document).permit(
      :vehicle_id, :admin_id, :document_type, :expiry_date
    )
  end
end
