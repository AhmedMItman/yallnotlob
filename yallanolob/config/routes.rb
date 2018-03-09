Rails.application.routes.draw do
  get 'friends/index'

  get 'home/index'
  get 'friends/', to: 'friends#index'

  resources :notifications
  resources :user_notifications
  resources :items
  resources :orders
  devise_for :users
  resources :groups
  resources :users
  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
