Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: 'devise_overrides/registrations'
  }

  authenticated :user do
    root 'dashboard#index', as: :authenticated_root
  end
  get 'dashboard/ranking'

  resources :games, only: [:index, :new, :create]

  root to: "site#index"
end
