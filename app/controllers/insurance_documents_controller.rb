class InsuranceDocumentsController < ApplicationController
  before_action :set_insurance_document, only: %i[show update destroy]

  # GET /insurance_documents
  def index
    documents = InsuranceDocument.includes(:vehicle, :admin)
    documents = documents.limit(params[:limit] || 20).offset(params[:offset] || 0)
    render json: documents, status: :ok
  end

  # GET /insurance_documents/:id
  def show
    render json: @insurance_document, status: :ok
  end

  # POST /insurance_documents
  def create
    document = InsuranceDocument.new(insurance_document_params)
    if document.save
      render json: document, status: :created
    else
      render json: { errors: document.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /insurance_documents/:id
  def update
    if @insurance_document.update(insurance_document_params)
      render json: @insurance_document, status: :ok
    else
      render json: { errors: @insurance_document.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /insurance_documents/:id
  def destroy
    @insurance_document.destroy
    head :no_content
  end

  private

  def set_insurance_document
    @insurance_document = InsuranceDocument.find(params[:id])
  end

  def insurance_document_params
    params.require(:insurance_document).permit(
      :vehicle_id,
      :admin_id,
      :document_type,
      :expiry_date
    )
  end
end
