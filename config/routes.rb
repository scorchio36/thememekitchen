Rails.application.routes.draw do

  get '/home', to: 'static_pages#home'

  get '/buffet', to: 'static_pages#buffet'

  get '/kitchen', to: 'posts#new'

  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'static_pages#home'

  resources :users
  resources :posts


end
