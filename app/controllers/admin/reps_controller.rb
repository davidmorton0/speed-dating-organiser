class Admin::RepsController < ApplicationController
  before_action :authenticate_admin!

  def index
    organisation = current_admin.organisation
    @reps = Rep.where(organisation: organisation).order(:email)
  end

  def edit
    @rep = Rep.find(rep_params)
  end

  def update
    rep = Rep.find(rep_params)
    rep.update(email: edit_rep_params[:email])

    redirect_to admin_reps_path, info: "Rep updated"
  end
  
  private

    def rep_params
      params.require(:id)
    end

    def edit_rep_params
      params.require(:rep).permit(:email)
    end
end
