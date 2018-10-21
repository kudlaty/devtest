require 'rails_helper'
require 'database_cleaner'

RSpec.describe Api::PublicController, type: :controller do
  before(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  describe "GET locations" do
    
    before(:context) do
      p1 = FactoryBot.create(:panel_provider, code: 'times_a')
      p2 = FactoryBot.create(:panel_provider, code: 'times_html')
      c = FactoryBot.create(:country, code: 'PL', panel_provider: p1)
      lg1 = FactoryBot.create(:location_group, name: 'group1', panel_provider: p1, country: c)
      lg2 = FactoryBot.create(:location_group, name: 'group2', panel_provider: p2, country: c)
      l1 = FactoryBot.create(:location, name: 'location1', location_group: lg1)
      l2 = FactoryBot.create(:location, name: 'location2', location_group: lg1)
      l3 = FactoryBot.create(:location, name: 'location3', location_group: lg2)
    end
    after(:context) do
      DatabaseCleaner.clean_with(:truncation)
    end
    
    context "success" do
      
      def get_locations
        get :locations, params: {
          country_code: 'pl'
        }
      end
      
      it "shold pass" do
        get_locations
        expect(response).to have_http_status 200
      end
      
      it "should return json with correct locations" do
        get_locations
        json_response = JSON.parse(response.body)
        expect(json_response.fetch('locations')).to contain_exactly 'location1', 'location2'
      end
      
    end
    context 'error' do
      it "for missing country code" do
        get :locations, params: {
          country_code: 'en'
        }
        expect(response).to have_http_status 404
      end
    end
    
  end
  describe "GET target_groups" do
    
    def get_target_groups
      get :target_groups, params: {
        country_code: 'en'
      }
    end
    
    before(:context) do
      p1 = FactoryBot.create(:panel_provider, code: 'times_a')
      p2 = FactoryBot.create(:panel_provider, code: 'times_html')
      c1 = FactoryBot.create(:country, code: 'PL', panel_provider: p1)
      c2 = FactoryBot.create(:country, code: "EN", panel_provider: p2)
      tg1 = FactoryBot.create(:target_group, name: "tg1", panel_provider: p1, countries: [c1, c2] )
      tg11 = FactoryBot.create(:target_group, name: 'tg11', parent_target_group: tg1 )
      tg111 = FactoryBot.create(:target_group, name: 'tg111', parent_target_group: tg11 )
      tg2 = FactoryBot.create(:target_group, name: 'tg2', panel_provider: p2, countries: [c1, c2])
      tg21 = FactoryBot.create(:target_group, name: 'tg21', parent_target_group: tg2 )
      tg22 = FactoryBot.create(:target_group, name: 'tg22', parent_target_group: tg2 )
      tg221 = FactoryBot.create(:target_group, name: 'tg221', parent_target_group: tg22 )
      tg222 = FactoryBot.create(:target_group, name: 'tg222', parent_target_group: tg22 )
    end
    after(:context) do
      DatabaseCleaner.clean_with(:truncation)
    end
    
    context "success" do
      it "should pass" do
        get_target_groups
        expect(response).to have_http_status(200)
      end
      it "should return correct target_group" do
        get_target_groups
        json_response = JSON.parse(response.body)
        expect(json_response.fetch('target_groups')).to include({'name' => 'tg2'})
        expect(json_response.fetch('target_groups')).to include({'name' => 'tg21', 'parent_target_group' => 'tg2'})
        expect(json_response.fetch('target_groups')).to include({'name' => 'tg22', 'parent_target_group' => 'tg2'})
        expect(json_response.fetch('target_groups')).to include({'name' => 'tg221', 'parent_target_group' => 'tg22'})
        expect(json_response.fetch('target_groups')).to include({'name' => 'tg222', 'parent_target_group' => 'tg22'})
      end
      it "should not return target groups from different panel provider" do
        get_target_groups
        json_response = JSON.parse(response.body)
        expect(json_response.fetch('target_groups')).to_not include({'name': 'tg1'})
        expect(json_response.fetch('target_groups')).to_not include({'name': 'tg11'})
        expect(json_response.fetch('target_groups')).to_not include({'name': 'tg111'})
      end
    end
    context 'error' do
      it "for missing country code" do
        get :target_groups, params: {
          country_code: 'missing'
        }
        expect(response).to have_http_status 404
      end
    end
  end
end
