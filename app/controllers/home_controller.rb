class HomeController < ApplicationController

  def index
  end

  def logout
    sign_out

    redirect_to '/'
  end

  def login_admin
    sign_out
    sign_in Admin.first

    redirect_to admin_events_path
  end
  
  def login_rep
    sign_out
    sign_in Rep.first

    redirect_to rep_events_path
  end

  def login_dater
    sign_out
    dater = Dater.first
    sign_in dater

    redirect_to dater_event_path(dater.event)
  end
end