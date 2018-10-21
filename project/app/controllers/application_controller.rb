require 'custom_exceptions'
class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from CustomException::Unauthorized, with: :unauthorized
  
  private
  
  def not_found
    render json: {errors: ['404 Page Not Found']}, status: 404
  end
  
  def unauthorized
    render json: {errors: ['You do not have permission']}, status: 401
  end
end
