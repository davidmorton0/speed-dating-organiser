class Admin::RepsController < ApplicationController
  before_action :authenticate_admin!

  def index
    organisation = current_admin.organisation
    @reps = Rep.where(organisation: organisation).order(:email)
  end

  def edit
    @rep = Rep.find(rep_params)
    redirect_to admin_reps_path unless @rep.organisation == current_admin.organisation
  end

  def update
    rep = Rep.find(rep_params)
    if rep.organisation == current_admin.organisation
      rep.update(email: edit_rep_params[:email])
      flash[:success] = 'Rep updated'
    end
    redirect_to admin_reps_path
  end

  def create
    Rep.invite!(email: email_params, organisation: current_admin.organisation)

    redirect_back(fallback_location: admin_reps_path)
  end

  def destroy
    @rep = Rep.find(rep_params)
    return unless @rep.organisation == current_admin.organisation

    @rep.destroy
    flash[:success] = 'Rep deleted'
    
    redirect_to admin_reps_path
  end

  def resend_invitation
    @rep = Rep.find(rep_params)
    return unless @rep.organisation == current_admin.organisation

    @rep.invite!
    redirect_back(fallback_location: admin_reps_path)
  end
  
  private

    def rep_params
      params.require(:id)
    end

    def edit_rep_params
      params.require(:rep).permit(:email)
    end

    def email_params
      params.require(:email)
    end
end
