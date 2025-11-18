FactoryBot.define do
  factory :message do
    association :message_campaign
    association :participant
  end
end
