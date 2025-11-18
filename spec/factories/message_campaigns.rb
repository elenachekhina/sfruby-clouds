FactoryBot.define do
  factory :message_campaign do
    name { "Name" }
    subject { "Subject" }
    body { "Body" }
    sent_messages_count { 0 }
    opened_messages_count { 0 }
    bounced_messages_count { 0 }
  end
end
