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

  def login_user
    sign_out
    sign_in User.first

    redirect_to user_event_path(Event.first)
  end
end