class Location < ApplicationRecord
  belongs_to :location_group
    
  validates :name, presence: true
  validates :external_id, presence: true, uniqueness: true
  validates :secret_code, presence: true
end
