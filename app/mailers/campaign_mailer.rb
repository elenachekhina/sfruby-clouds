class CampaignMailer < ApplicationMailer
  before_action do
    @message = params[:message]
    @participant = @message.recipient
  end

  def mailing
    mail(
      to: @message.recipient.email,
      subject: @message.subject
    )
  end
end
