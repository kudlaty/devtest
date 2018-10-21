module SharedValidations
  extend ActiveSupport::Concern
  
  included do
    validates :external_id, presence: true, uniqueness: true
    validates :secret_code, presence: true
  end
  
end
