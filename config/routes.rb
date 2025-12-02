Rails.application.routes.draw do
  devise_for :users

  # Admin namespace
  namespace :admin do
    root 'dashboard#index'
    resources :products
    resources :categories
    resources :orders, only: [:index, :show] do
      member do
        patch :update_status
      end
    end
    resources :customers, only: [:index, :show]
    resources :provinces, only: [:index, :edit, :update]
  end

  # Public routes (to be created next)
  root 'products#index'
  resources :products, only: [:index, :show]
  resources :categories, only: [:show]

  # Cart routes
  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]

  # Order routes
  resources :orders, only: [:index, :show, :new, :create]

  # Customer profile
  resource :profile, only: [:show, :new, :create, :edit, :update]
end