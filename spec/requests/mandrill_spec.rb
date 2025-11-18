require "rails_helper"

describe "/webhooks/mandrill" do
  let_it_be(:participant) { create(:participant, full_name: "Vova", email: "vova@sf.test") }
  let_it_be(:invitation) { participant.invitations.create! }

  let_it_be(:another_participant) { create(:participant, full_name: "John", email: "john@sf.test") }
  let_it_be(:another_invitation) { another_participant.invitations.create! }

  let_it_be(:message_campaign) { create(:message_campaign) }
  let_it_be(:message) { create(:message, participant:, message_campaign:) }
  let_it_be(:another_message) { create(:message, participant:, message_campaign:) }

  describe "POST /create" do
    let(:events) do
      [
        {
          "event" => "open",
          "ts" => 1365109999,
          "msg" => {
            "ts" => 1365109999,
            "subject" => "Test Subject",
            "email" => "vova@sf.test",
            "sender" => "noreply@example.com",
            "tags" => ["invitation"],
            "opens" => [
              {
                "ts" => 1365109999
              }
            ],
            "_id" => "abc123def456ghi789",
            "state" => "sent",
            "metadata" => {
              "trackable_type" => "Invitation",
              "trackable_id" => invitation.id
            }
          }
        },
        {
          "event" => "hard_bounce",
          "ts" => 1365110000,
          "msg" => {
            "ts" => 1365110000,
            "subject" => "Test Subject",
            "email" => "john@sf.test",
            "sender" => "noreply@example.com",
            "tags" => ["invitation"],
            "bounce_description" => "bad_mailbox",
            "bgtools_code" => 10,
            "diag" => "smtp;550 5.1.1 The email account that you tried to reach does not exist.",
            "_id" => "def456ghi789jkl012",
            "state" => "bounced",
            "metadata" => {
              "trackable_type" => "Invitation",
              "trackable_id" => another_invitation.id
            }
          }
        },
        {
          "event" => "open",
          "ts" => 1365109999,
          "msg" => {
            "ts" => 1365109999,
            "subject" => "Test Subject",
            "email" => "vova@sf.test",
            "sender" => "noreply@example.com",
            "tags" => ["campaign"],
            "opens" => [
              {
                "ts" => 1365109999
              }
            ],
            "_id" => "abc123def456ghi789",
            "state" => "sent",
            "metadata" => {
              "trackable_type" => "Message",
              "trackable_id" => message.id
            }
          }
        },
        {
          "event" => "hard_bounce",
          "ts" => 1365110000,
          "msg" => {
            "ts" => 1365110000,
            "subject" => "Test Subject",
            "email" => "john@sf.test",
            "sender" => "noreply@example.com",
            "tags" => ["campaign"],
            "bounce_description" => "bad_mailbox",
            "bgtools_code" => 10,
            "diag" => "smtp;550 5.1.1 The email account that you tried to reach does not exist.",
            "_id" => "def456ghi789jkl012",
            "state" => "bounced",
            "metadata" => {
              "trackable_type" => "Message",
              "trackable_id" => another_message.id
            }
          }
        }
      ]
    end

    let(:signature) do
      Base64.encode64(
        OpenSSL::HMAC.digest(
          "sha1",
          "test-2025-key",
          "#{webhooks_mandrill_url}mandrill_events#{events.to_json}"
        )
      ).strip
    end

    subject { post webhooks_mandrill_url, params: "mandrill_events=#{URI.encode_www_form_component(events.to_json)}", headers: {"X-Mandrill-Signature" => signature, "Content-Type" => "application/x-www-form-urlencoded"} }

    it "succeeds" do
      subject
      expect(response).to be_successful, "Unexpected response code: #{response.code}"
    end

    it "updates invitations statuses" do
      expect { subject }.to change { invitation.reload.status }.from("sent").to("opened")
        .and change { another_invitation.reload.status }.from("sent").to("bounced")
        .and change { another_participant.reload.email_notifications_enabled }.from(true).to(false)
    end

    it "updates message opened_at" do
      expect { subject }.to change { message.reload.status }.from("sent").to("opened")
        .and change { another_message.reload.status }.from("sent").to("bounced")
    end

    context "with incorrect signature" do
      let(:signature) { "bla-bla" }

      it "is unauthorized" do
        subject
        expect(response).to be_unauthorized, "Unexpected response code: #{response.code}"
      end
    end
  end
end
