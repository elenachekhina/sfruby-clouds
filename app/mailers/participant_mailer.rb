class ParticipantMailer < ApplicationMailer
  before_action do
    headers["X-MC-Track"] = "opens, clicks_htmlonly"
    headers["X-MC-Metadata"] = { delivery_id: params[:delivery]&.id }.compact.to_json
  end

  def welcome
    @url = participant_home_url(access_token: participant.access_token)

    mail(
      to: participant.email,
      subject: "Create Your SF Ruby Cloud Card ☁️"
    )
  end

  def campaign
    @campaign = params[:campaign]

    mail(
      to: participant.email,
      subject: @campaign.subject
    )
  end
end
