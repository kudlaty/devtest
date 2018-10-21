class User < ApplicationRecord

  validates :email, presence: true, uniqueness: true
  
  class << self
    def find_by_token token
      email = Token.decode(token).try(:fetch, 'user_email')
      self.find_by(email: email)
    end
  end
  
  def token
    Token.new({user_email: email}).encode
  end
end
