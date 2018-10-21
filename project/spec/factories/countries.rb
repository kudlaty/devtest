FactoryBot.define do
  factory :country do
    code { FFaker::Address.country_code }
  end
end
