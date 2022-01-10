Rails.application.routes.draw do
  resources :events
  resources :daters, only: [:create]
end
