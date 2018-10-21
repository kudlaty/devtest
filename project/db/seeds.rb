Rake::Task["db:drop"].invoke
Rake::Task["db:create"].invoke
Rake::Task["db:migrate"].invoke

PANEL_PROVIDERS_CODES = %w[times_a 10_arrays times_html].freeze

COUNTRIES = [
  { code: "PL", panel_provider_code: "times_a" },
  { code: "US", panel_provider_code: "10_arrays" },
  { code: "UK", panel_provider_code: "times_html" }
].freeze

LOCATION_GROUPS = [
  { name: "LG1 #{FFaker::AddressUS.state}", panel_provider_code: "times_a", country_code: "PL" },
  { name: "LG2 #{FFaker::AddressUS.state}", panel_provider_code: "10_arrays", country_code: "US" },
  { name: "LG3 #{FFaker::AddressUS.state}", panel_provider_code: "times_html", country_code: "UK" },
  { name: "LG4 #{FFaker::AddressUS.state}", panel_provider_code: "times_a", country_code: "US" }
]

LOCATIONS = [
  { name: "New York" },
  { name: "Los Angeles" },
  { name: "Chicago" },
  { name: "Houston" },
  { name: "Philadelphia" },
  { name: "Phoenix" },
  { name: "San Antonio" },
  { name: "San Diego" },
  { name: "Dallas" },
  { name: "San Jose" },
  { name: "Austin" },
  { name: "Jacksonville" },
  { name: "San Francisco" },
  { name: "Indianapolis" },
  { name: "Columbus" },
  { name: "Fort Worth" },
  { name: "Charlotte" },
  { name: "Detroit" },
  { name: "El Paso" },
  { name: "Seattle" }
].freeze

TARGET_GROUPS = [
  { name: "TG1 #{FFaker::Lorem.word}", panel_provider_code: 'times_a', country_codes: ['PL','US'] },
  { name: "TG2 #{FFaker::Lorem.word}", panel_provider_code: '10_arrays', country_codes: ['PL','US','UK'] },
  { name: "TG3 #{FFaker::Lorem.word}", panel_provider_code: 'times_html', country_codes: ['US'] },
  { name: "TG4 #{FFaker::Lorem.word}", panel_provider_code: PANEL_PROVIDERS_CODES.sample, country_codes: ['US','UK'] }
].freeze

USERS = [
  { email: "testing@email.com" }
].freeze

USERS.each do |user|
  User.create!(email: user.fetch(:email))
end

PANEL_PROVIDERS_CODES.each { |panel_provider_code| PanelProvider.create!(code: panel_provider_code) }

COUNTRIES.each do |country|
  Country.create!(
    code: country.fetch(:code),
    panel_provider: PanelProvider.find_by!(code: country.fetch(:panel_provider_code))
  )
end

LOCATION_GROUPS.each do |location_group|
  LocationGroup.create!(
    name: location_group.fetch(:name),
    panel_provider: PanelProvider.find_by!(code: location_group.fetch(:panel_provider_code)),
    country: Country.find_by!(code: location_group.fetch(:country_code))
  )
end

LOCATIONS.each do |location|
  Location.create!(
    name: location.fetch(:name),
    location_group: LocationGroup.all.sample,
    external_id: SecureRandom.uuid,
    secret_code: SecureRandom.hex(64)
  )
end

def child_target_groups level, max_level
  return [] if level > max_level
  (1..rand(2..6)).map do
    TargetGroup.create!(
      name: FFaker::Lorem.word.capitalize,
      external_id: SecureRandom.uuid,
      secret_code: SecureRandom.hex(64),
      target_groups: child_target_groups(level+1, max_level)
    )
  end
end

TARGET_GROUPS.each do |tg|
  TargetGroup.create!(
    name: tg.fetch(:name).capitalize,
    panel_provider: PanelProvider.find_by!(code: tg.fetch(:panel_provider_code)),
    external_id: SecureRandom.uuid,
    secret_code: SecureRandom.hex(64),
    target_groups: child_target_groups(1, rand(3..5)),
    countries: Country.where(code: tg.fetch(:country_codes))
  )
end
