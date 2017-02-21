Rails.application.routes.draw do

  get '/home', to: 'static_pages#home'

  get '/buffet', to: 'static_pages#buffet'

  get '/kitchen', to: 'posts#new'

  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'

  post 'static_pages/handle_next' => 'static_pages#handle_next'
  post 'static_pages/handle_prev' => 'static_pages#handle_prev'
  post 'static_pages/handle_like' => 'static_pages#handle_like'
  post 'static_pages/handle_dislike' => 'static_pages#handle_dislike'

  post 'comments/handle_like' => 'comments#handle_like'
  post 'comments/handle_dislike' => 'comments#handle_dislike'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'static_pages#home'

  resources :users
  resources :posts
  resources :comments, except: [:show]


end
