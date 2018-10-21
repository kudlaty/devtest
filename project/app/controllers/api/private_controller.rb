require 'custom_exceptions'
class Api::PrivateController < Api::PrivatePublicController
  
  before_action :authorize_user
  
  def evaluate_target
    
    evaluate_target = EvaluateTarget.new(params)
    
    unless evaluate_target.valid?
      render json: {errors: evaluate_target.errors.full_messages}, status: 422
    else
      render json: {
        success: true,
        price: evaluate_target.price
      }
    end
  end
  
  private
  
  def authorize_user
    token = request.env["HTTP_AUTHORIZATION"].try(:gsub!, /^Bearer /, '')
    raise CustomException::Unauthorized unless token and User.find_by_token(token)
  end
  
  
end
