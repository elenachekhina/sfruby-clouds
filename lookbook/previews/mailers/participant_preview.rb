module Mailers
  class ParticipantPreview < ApplicationMailerPreview
    def welcome
      participant = Participant.new(full_name: "IriNa", email: "in@sfruby.test", access_token: "test-42")

      render_email(ParticipantMailer.with(participant:).welcome)
    end
  end
end
