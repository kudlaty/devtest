class TargetGroup < ApplicationRecord
  has_and_belongs_to_many :countries
  
  scope :parent, -> {where(parent_id: nil)}
end
