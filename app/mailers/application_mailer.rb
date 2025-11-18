class ApplicationMailer < ActionMailer::Base
  layout "mailer"

  append_view_path Rails.root.join("app/views/mailers")

  helper MarkdownHelper
  helper_method :participant
  attr_reader :participant

  before_action do
    next unless params

    @participant = params[:participant]
    @trackable = params[:trackable]
  end

  before_action do
    attachments.inline["sfruby_email.png"] = Rails.public_path.join("sfruby_email.png").read
  end

  # Email action used to check that mailing configuration is correct.
  #
  # You can send it via the Rake task
  #
  #   dip rake "checks:send_email[some@mail.dev]"
  def check(email, body)
    @body = body
    mail(
      to: email,
      subject: "Test email from SF Ruby Clouds [#{Rails.env}]"
    )
  end
end
