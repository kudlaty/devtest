class LocationGroup < ApplicationRecord
  has_many :locations
  belongs_to :panel_provider
  belongs_to :country
end
