Rails.application.routes.draw do
  resources :events do
    resources :speed_dates, only: [:create, :update]
  end
  resources :daters, only: [:create]

end
