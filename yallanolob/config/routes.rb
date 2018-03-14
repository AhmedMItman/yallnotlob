Rails.application.routes.draw do

  resources :orders
  resources :friendships
  get 'friends/index'
  get 'home/index'
  get 'friends/', to: 'friends#index'
  resources :notifications
  resources :user_notifications
  resources :items
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :groups
  resources :users
  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
