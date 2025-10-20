require "rails_helper"

describe Participant do
  describe ".create" do
    it "normalizes email" do
      participant = build(:participant, email: "TestMe@ex.com ")
      participant.save!

      expect(participant.email).to eq("testme@ex.com")
    end

    it "generates an access token if not provided" do
      participant = build(:participant, access_token: nil)
      participant.save!

      expect(participant.access_token).not_to be_nil
    end
  end
end
