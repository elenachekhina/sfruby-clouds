class ParticipantMailer < ApplicationMailer
  def welcome
    @url = participant_home_url(access_token: participant.access_token)
    mail(
      to: participant.email,
      subject: "Create Your SF Ruby Cloud Card ☁️"
    )
  end
end
