FactoryBot.define do
  factory :panel_provider do
    trait :times_a do
      code { 'times_a' }
    end
    trait "10_arrays" do
      code { '10_arrays'}
    end
    trait :times_html do
      code { 'times_html'}
    end
  end
end
