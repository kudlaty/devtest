Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root controller: :pages, action: :root
  
  namespace :api do
    
    concern :private_public do
      get :locations, path: "locations/:country_code"
      get :target_groups, path: "target_groups/:country_code"
    end
    
    scope path: "", controller: :public, format: false do
      concerns :private_public
    end
    
    scope path: "private", controller: :private, format: false, as: :private do
      concerns :private_public
      post :evaluate_target
    end
    
  end
end
