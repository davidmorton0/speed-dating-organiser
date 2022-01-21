Rails.application.routes.draw do
  devise_for :reps
  devise_for :admins
  devise_for :users

  root to: "home#index"
  get "/login_admin", to: "home#login_admin"
  get "/login_rep", to: "home#login_rep"
  get "/login_user", to: "home#login_user"


  namespace :admin do
    resources :events do
      resources :speed_dates, only: [:create, :update, :index]
      resources :daters, only: [:create, :update, :index, :show]
      get '/matches', as: 'matches', to: 'daters#matches'
    end
  end

  namespace :rep do
    resources :events do
      resources :speed_dates, only: [:create, :update, :index]
      resources :daters, only: [:create, :update, :index, :show]
      get '/matches', as: 'matches', to: 'daters#matches'
    end
  end

  namespace :user do
    resources :events do
      resources :speed_dates, only: [:index]
      resources :daters, only: [:update, :show]
    end
  end
end
