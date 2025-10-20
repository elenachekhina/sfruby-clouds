FactoryBot.define do
  sequence(:email_number)

  factory :participant do
    email { "user-#{generate(:email_number)}@sfruby.test" }
    full_name { Faker::Name.name }
  end
end
