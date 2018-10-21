require 'rails_helper'

RSpec.describe EvaluateTarget, type: :model do
  before(:all) do
    DatabaseCleaner.strategy = :transaction
  end
  
  describe "validations" do
    before(:context) do
      p = FactoryBot.create(:panel_provider, :times_a)
      c = FactoryBot.create(:country, panel_provider: p)
      FactoryBot.create(:target_group)
      lg = FactoryBot.create(:location_group, country: c, panel_provider: p)
      FactoryBot.create(:location, name: 'loc1', location_group: lg)
      FactoryBot.create(:location, name: 'loc2', location_group: lg)
    end
    after(:context) do
      DatabaseCleaner.clean_with(:truncation)
    end
    
    let (:country){ Country.first }
    let (:target_group){ TargetGroup.first }
    let (:location1){ Location.first }
    let (:location2){ Location.last }
    
    def initializers
      {
        country_code: country.code,
        target_group_id: target_group.id,
        locations: [
          {id: location1.id, panel_size: 200},
          {id: location2.id, panel_size: 300}
        ]
      }
    end
    
    describe 'presence' do
      it 'should pass' do
        et = EvaluateTarget.new(initializers)
        expect(et.valid?).to be true
      end
      context 'should raise error' do
        it "for missing country_code" do
          args = initializers
          args.delete(:country_code)
          et = EvaluateTarget.new(args)
          expect(et.valid?).to be false
        end
        it "for missing target_group_id" do
          args = initializers
          args.delete(:target_group_id)
          et = EvaluateTarget.new(args)
          expect(et.valid?).to be false
        end
        it "for missing locations" do
          args = initializers
          args.delete(:locations)
          et = EvaluateTarget.new(args)
          expect(et.valid?).to be false
        end
        it "for wrong country_code" do
          args = initializers
          args[:country_code] = "wrong"
          et = EvaluateTarget.new(args)
          expect(et.valid?).to be false
        end
      end
    end
  end
end
