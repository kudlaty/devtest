class Country < ApplicationRecord
  belongs_to :panel_provider
  has_many :location_groups
  has_and_belongs_to_many :target_groups, ->{ main }

  validates :code, presence: true, uniqueness: true
  validates :panel_provider, presence: true
  
  def provider_locations
    location_groups.for_provider_with_locations(panel_provider_id).map{|lg| lg.locations }.flatten
  end
  def provider_target_groups
    target_groups.for_provider(panel_provider_id)
  end
end
