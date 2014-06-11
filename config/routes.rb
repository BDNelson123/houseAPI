House::Application.routes.draw do
  resources :users
  resources :sessions
  resources :homes
  resources :images
  resources :searches
end
