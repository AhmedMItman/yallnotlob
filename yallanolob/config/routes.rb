Rails.application.routes.draw do

  resources :orders
  resources :friendships
  resources :home

  
  get 'friends/index'
  get 'home/index'
  get 'friends/', to: 'friends#index'
  get 'groupfriends', to: 'groups#groupfriends'
  post 'remove_friend_from_group', to: 'groups#remove_friend_from_group'
  post 'add_friend_to_group', to: 'groups#add_friend_to_group'
  get 'userfriends', to: 'groups#userfriends'
  resources :notifications
  resources :user_notifications
  resources :items


  devise_for :users ,  :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :groups
  resources :users
  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
