FactoryBot.define do
  factory :message_campaign do
    subject { "MyString" }
    body { "MyText" }
    sent_messages_count { 0 }
    opened_messages_count { 0 }
    bounced_messages_count { 0 }
  end
end
