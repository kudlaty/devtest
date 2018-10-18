class Api::PublicController < ApplicationController
  
  def locations
    
  end
  
  def target_groups
    
  end
  
  private
  
  def country_code_param
    params.permit(:country_code)
  end
end
