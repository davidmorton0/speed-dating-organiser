# frozen_string_literal: true

class Admin::OrganisationsController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    current_admin.organisation.destroy

    flash[:success] = 'Account deleted'

    sign_out current_admin
    redirect_to root_path
  end
end
