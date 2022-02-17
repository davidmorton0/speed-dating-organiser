Rails.application.routes.draw do
  devise_for :daters
  devise_for :reps
  devise_for :admins

  root to: 'home#index'
  get '/logout', to: 'home#logout'
  post '/login/:resource', as: 'login', to: 'home#login_resource'

  namespace :admin do
    resources :organisations, only: %i[destroy]
    resources :events do
      resources :speed_dates, only: %i[create update index]
      resources :daters, only: %i[create update index show]
      get '/matches', as: 'matches', to: 'daters#matches'
      post '/send_match_emails', as: 'send_match_emails', to: 'daters#send_match_emails'
    end

    resources :reps, only: %i[create edit update index destroy]
    patch '/rep/resend_invitation/:id', as: 'rep/resend_invitation', to: 'reps#resend_invitation'
  end

  namespace :rep do
    resources :events do
      resources :speed_dates, only: %i[create update index]
      resources :daters, only: %i[create update index show]
      get '/matches', as: 'matches', to: 'daters#matches'
    end
  end

  namespace :dater do
    resources :events do
      resources :speed_dates, only: [:index]
      resources :daters, only: %i[update show]
    end
  end
end
