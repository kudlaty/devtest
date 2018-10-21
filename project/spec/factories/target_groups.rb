FactoryBot.define do
  factory :target_group do
    name { FFaker::Lorem.word.capitalize }
    external_id { SecureRandom.uuid }
    secret_code { SecureRandom.hex(64) }
  end
end
