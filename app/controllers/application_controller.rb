class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate_admin!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from StandardError, with: :internal_server_error

  private

  def authenticate_admin!
    # Devise JWT authentication
    authenticate_admin!
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value
    }
  end

  def record_not_found(exception)
    render json: { error: "Record not found", message: exception.message }, status: :not_found
  end

  def record_invalid(exception)
    render json: { error: "Validation failed", message: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def internal_server_error(exception)
    render json: { error: "Internal server error", message: exception.message }, status: :internal_server_error
  end
end
