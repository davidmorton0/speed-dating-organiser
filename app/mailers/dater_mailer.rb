class DaterMailer < ApplicationMailer
  default from: Rails.application.credentials.mailer.sender

  def matches_email
    @dater = params[:dater]
    @matches = params[:matches]
    mail(to: @dater.email, subject: 'Here are your matches')
  end
end
