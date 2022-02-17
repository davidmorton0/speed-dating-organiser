# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DaterMailer do
  describe '#matches_email' do
    let(:dater) { build(:dater) }
    let(:matches) { build_list(:dater, 2) }
    let(:mail) { described_class.matches_email(dater, matches) }

    it 'renders the subject' do
      expect(mail.subject).to eql('Here are your matches')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([dater.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['speeddatingorganiser@gmail.com'])
    end

    it 'assigns @dater' do
      expect(mail.body.encoded).to match(CGI.escapeHTML(dater.name))
    end

    it 'assigns @matches' do
      matches.each do |match|
        expect(mail.body.encoded).to match(CGI.escapeHTML(match.name))
      end
    end
  end
end
