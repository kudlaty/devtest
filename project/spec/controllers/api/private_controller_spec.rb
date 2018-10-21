require 'rails_helper'

RSpec.describe Api::PrivateController, type: :controller do
  before(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  describe "Authorization" do
    before(:context) do
      p1 = FactoryBot.create(:panel_provider, code: 'times_a')
      c = FactoryBot.create(:country, code: 'PL', panel_provider: p1)
    end
    after(:context) do
      DatabaseCleaner.clean_with(:truncation)
    end
    let(:user){FactoryBot.create(:user)}
    context "with authorization header" do
      
      before(:example) do
        request.env['HTTP_AUTHORIZATION'] = "Bearer #{user.token}"
      end
      
      it "GET locations should pass" do
        get :locations, params: { country_code: 'pl' }
        expect(response).to have_http_status(200)
      end
      
      it "GET target_group should pass" do
        get :locations, params: { country_code: 'pl'}
        expect(response).to have_http_status(200)
      end
      
      it "should rise error when token is wrong" do
        
        request.env['HTTP_AUTHORIZATION'] = "Bearer wrongtoken"
        
        get :locations, params: { country_code: 'p1' }
        expect(JSON.parse(response.body).fetch('errors')).to be_present
        expect(response).to have_http_status(401)
      end
      
    end
    context "witout authorization header" do
      it "GET locations should return error" do
        
        get :locations, params: {country_code: 'p1'}
        expect(JSON.parse(response.body).fetch('errors')).to be_present
        expect(response).to have_http_status(401)
        
      end
    end
  end

  describe "POST evaluate_target" do
    
    let(:user){ User.first }
    
    before(:all) { FactoryBot.create(:user) }
    after(:all) { DatabaseCleaner.clean_with(:truncation) }
    
    # before(:context) do
    #   FactoryBot.create(:target_group)
    #   FactoryBot.create(:location)
    # end
    
    before(:example) do
      request.env['HTTP_AUTHORIZATION'] = "Bearer #{user.token}"
    end
    context "should pass" do
      let(:country) { FactoryBot.create(:country, panel_provider: FactoryBot.create(:panel_provider, :times_a)) }
      
      def post_evaluate_target
        post :evaluate_target, params: {
          country_code: country.code,
          target_group_id: 1,
          locations: [{ id: 2, panel_zise: 200}]
        }
      end
      
      it "should have status 200" do
        post_evaluate_target
        expect(response).to have_http_status 200
      end
      
      it "should return price" do
        post_evaluate_target
        json_response = JSON.parse(response.body)
        expect(json_response.fetch('price')).to be_present
      end
      
    end
    
    context "should return error" do
      
      it "when missing :code_country" do
        post :evaluate_target, params: {
          target_group_id: 1,
          locations: [{ id: 2, panel_size: 100 }]
        }
        expect(response).to have_http_status 422
      end
      
      it "when missing :target_group_id" do
        post :evaluate_target, params: {
          country_code: 'pl',
          locations: { id: 2, panel_size: 100 }
        }
        expect(response).to have_http_status 422
      end
      
      it "when missing :locations" do
        post :evaluate_target, params: {
          target_group_id: 1,
          country_code: "pl"
        }
        expect(response).to have_http_status 422
      end
      
    end
  end

end
