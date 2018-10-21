class TargetGroup < ApplicationRecord
  
  include SharedValidations
  
  has_and_belongs_to_many :countries
  has_many :target_groups, ->{includes(:target_groups)}, foreign_key: :parent_id
  belongs_to :parent_target_group, foreign_key: :parent_id, optional: true, class_name: "TargetGroup"
  belongs_to :panel_provider, optional: true
  
  scope :main, ->{where(parent_id: nil)}
  scope :for_provider, ->(panel_provider_id) { where(panel_provider_id: panel_provider_id).includes(:target_groups)}
  
  validates :name, presence: true
  
  def get_mapped_target_groups
    arr = []
    arr.push({name: name}) if parent_id.blank?
    (arr + target_groups.map { |tg|
      [{name: tg.name, parent_target_group: name},*tg.get_mapped_target_groups]
    }).flatten
  end
  
end
