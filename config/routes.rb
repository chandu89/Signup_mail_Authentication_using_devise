Rails.application.routes.draw do
  resources :posts
  devise_for :users
  resources :home

  # You can have the root of your site routed with "root"
  root 'home#index'

 	namespace :api do
	  namespace :v1 do
	    resources :posts
	  end
	end 
end
