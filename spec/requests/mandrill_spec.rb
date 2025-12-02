require "rails_helper"

describe "/webhooks/mandrill" do
  let_it_be(:participant) { create(:participant, full_name: "Vova", email: "vova@sf.test") }
  let_it_be(:delivery) { participant.deliveries.create! deliverable: Invitation.new }

  let_it_be(:another_participant) { create(:participant, full_name: "John", email: "john@sf.test") }
  let_it_be(:another_delivery) { another_participant.deliveries.create! deliverable: Invitation.new }

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
            "tags" => ["delivery"],
            "opens" => [
              {
                "ts" => 1365109999
              }
            ],
            "_id" => "abc123def456ghi789",
            "state" => "sent",
            "metadata" => {
              "delivery_id" => delivery.id
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
            "tags" => ["delivery"],
            "bounce_description" => "bad_mailbox",
            "bgtools_code" => 10,
            "diag" => "smtp;550 5.1.1 The email account that you tried to reach does not exist.",
            "_id" => "def456ghi789jkl012",
            "state" => "bounced",
            "metadata" => {
              "delivery_id" => another_delivery.id
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

    it "updates deliveries statuses" do
      expect { subject }.to change { delivery.reload.status }.from("sent").to("opened")
        .and change { another_delivery.reload.status }.from("sent").to("bounced")
        .and change { another_participant.reload.email_notifications_enabled }.from(true).to(false)
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
