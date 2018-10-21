require 'jwt'
class Token

  attr_accessor :payload
  
  class << self
    def decode token_str
      begin
        self.new(payload: JWT.decode(token_str, Rails.application.secrets.jwt_secret).first ).args
      rescue JWT::VerificationError, JWT::DecodeError
        return nil
      end
    end

  end
  
  def initialize hash
    raise TypeError unless hash.is_a? Hash
    self.payload = hash
  end
  
  # def add hash=Hash.new
  #   raise TypeError unless hash.is_a? Hash
  #   self.payload = self.payload.merge(hash)
  # end
  
  def encode
    JWT.encode self.payload, Rails.application.secrets.jwt_secret
  end
  
  def args
    payload.fetch(:payload)
  end
  
  # private
  
  # def generate_token
  #   self.token = loop do
  #     random_token = SecureRandom.urlsafe_base64(64, false)
  #     break random_token unless Token.exists?(token: random_token)
  #   end
  # end
  
end
