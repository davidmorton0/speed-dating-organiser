Rails.application.routes.draw do
  devise_for :daters
  devise_for :reps
  devise_for :admins

  root to: "home#index"
  get "/logout", to: "home#logout"
  post "/login/:resource", to: "home#login_resource"

  namespace :admin do
    resources :events do
      resources :speed_dates, only: [:create, :update, :index]
      resources :daters, only: [:create, :update, :index, :show]
      get '/matches', as: 'matches', to: 'daters#matches'
    end

    resources :reps, only: [:create, :edit, :update, :index, :destroy]
  end

  namespace :rep do
    resources :events do
      resources :speed_dates, only: [:create, :update, :index]
      resources :daters, only: [:create, :update, :index, :show]
      get '/matches', as: 'matches', to: 'daters#matches'
    end
  end

  namespace :dater do
    resources :events do
      resources :speed_dates, only: [:index]
      resources :daters, only: [:update, :show]
    end
  end
end
