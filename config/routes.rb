Rails.application.routes.draw do
  devise_for :users
  resources :home

  # You can have the root of your site routed with "root"
  root 'home#index'

  
end
