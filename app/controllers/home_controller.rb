class HomeController < ApplicationController

  def index
    if current_admin
      redirect_to admin_events_path
    elsif current_rep
      redirect_to rep_events_path
    elsif current_dater
      redirect_to dater_event_path(current_dater.event)
    end
  end

  def logout
    sign_out

    redirect_to '/'
  end

  def login_resource
    sign_out

    resource_name = params[:resource].to_s

    user = resource_name.capitalize.constantize.find_by(email: login_params(resource_name))
    sign_in user
    
    case resource_name
    when 'admin'
      redirect_to admin_events_path
    when 'rep'
      redirect_to rep_events_path
    when 'dater'
      redirect_to dater_event_path(current_dater.event)
    end
  end

  private

  def login_params(resource_name)
    params.require(resource_name.to_sym)
  end
end