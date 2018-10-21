class Location < ApplicationRecord
  include SharedValidations
  
  belongs_to :location_group
    
  validates :name, presence: true
  
end
