class Api::PrivatePublicController < ApplicationController

  skip_forgery_protection
  
  def locations
    
    raise ActionController::RoutingError.new('Not Found') unless current_country
    
    render json: {
      success: true,
      locations: current_country.provider_locations.map{|l| l.name }
    }
    
  end
  
  def target_groups
    raise ActionController::RoutingError.new('Not Found') unless current_country
      render json: {
        success: true,
        target_groups: current_country.provider_target_groups.map{|tg| tg.get_mapped_target_groups }.flatten
      }
  end
  
  private
  
  def country_code_param
    params.require(:country_code)
  end
  
  def current_country
    return @current_country if defined?(@current_country)
    @current_coutnry = Country.find_by(code: country_code_param.to_s.upcase)
  end
  
end
