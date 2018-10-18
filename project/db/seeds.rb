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
  { name: "Location Group 1", panel_provider_code: "times_a", country_code: "PL" },
  { name: "Location Group 2", panel_provider_code: "10_arrays", country_code: "US" },
  { name: "Location Group 3", panel_provider_code: "times_html", country_code: "UK" },
  { name: "Location Group 4", panel_provider_code: "times_a", country_code: "US" }
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
