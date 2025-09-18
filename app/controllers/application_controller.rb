class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate_request

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from StandardError, with: :internal_server_error

  private

  def authenticate_request
    # Basic token authentication - replace with JWT or proper auth system
    authenticate_or_request_with_http_token do |token, options|
      # For now, accept any token - implement proper authentication
      token.present?
    end
  end

  def current_admin
    # Placeholder for current admin - implement based on auth system
    @current_admin ||= Admin.first # Replace with proper lookup
  end

  def record_not_found(exception)
    render json: { error: 'Record not found', message: exception.message }, status: :not_found
  end

  def record_invalid(exception)
    render json: { error: 'Validation failed', message: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def internal_server_error(exception)
    render json: { error: 'Internal server error', message: exception.message }, status: :internal_server_error
  end
end
