class LocationGroup < ApplicationRecord
  has_many :locations
  belongs_to :panel_provider
  belongs_to :country

  scope :for_provider_with_locations, ->(panel_provider_id) { where(panel_provider_id: panel_provider_id).includes(:locations)}
  
end
