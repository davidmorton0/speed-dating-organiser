Rails.application.routes.draw do

  get '/', to: redirect('/events')

  resources :events do
    resources :speed_dates, only: [:create, :update]
  end
  resources :daters, only: [:create]

end
