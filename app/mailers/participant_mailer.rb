class ParticipantMailer < ApplicationMailer
  def welcome
    @url = participant_home_url(access_token: participant.access_token)

    headers["X-MC-Track"] = "opens, clicks_htmlonly"
    headers["X-MC-Metadata"] = {invitation_id: params[:invitation]&.id}.compact.to_json

    mail(
      to: participant.email,
      subject: "Create Your SF Ruby Cloud Card ☁️"
    )
  end
end
