class EvaluateTarget
  include ActiveModel::Validations
  
  attr_accessor :country_code, :target_group_id, :locations
  
  def initialize args = {}
    self.country_code = args[:country_code]
    self.target_group_id = args[:target_group_id]
    self.locations = args[:locations]
  end
  
  validates_presence_of :country_code, :target_group_id, :locations
  
  def price
    Country.find_by(code: country_code).panel_provider.price
  end
end
