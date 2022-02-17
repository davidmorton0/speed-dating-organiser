# frozen_string_literal: true

class DaterMailer < ApplicationMailer
  default from: Rails.application.credentials.mailer.sender

  def matches_email(dater, matches)
    @dater = dater
    @matches = matches
    mail(to: dater.email, subject: 'Here are your matches')
  end
end
