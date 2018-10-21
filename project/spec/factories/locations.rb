FactoryBot.define do
  factory :location do
    name { FFaker::Address.city }
    external_id { SecureRandom.uuid }
    secret_code { SecureRandom.hex(64) }
  end
end
