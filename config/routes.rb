Rails.application.routes.draw do

  get '/home', to: 'main_courses#home'
  get '/buffet', to: 'static_pages#buffet'
  get '/kitchen', to: 'posts#new'
  get '/users/user_posts_feed', to: 'users#user_posts_feed'

  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'

  post 'static_pages/handle_next' => 'static_pages#handle_next'
  post 'static_pages/handle_prev' => 'static_pages#handle_prev'
  post 'static_pages/handle_like' => 'static_pages#handle_like'
  post 'static_pages/handle_dislike' => 'static_pages#handle_dislike'
  post 'static_pages/handle_main_course' => 'static_pages#handle_main_course'

  post 'main_courses/handle_next' => 'main_courses#handle_next'
  post 'main_courses/handle_prev' => 'main_courses#handle_prev'
  post 'main_courses/handle_like' => 'main_courses#handle_like'
  post 'main_courses/handle_dislike' => 'main_courses#handle_dislike'
  post 'main_courses/handle_main_course' => 'main_courses#handle_main_course'


  post 'users/handle_next' => 'users#handle_next'
  post 'users/handle_prev' => 'users#handle_prev'
  post 'users/handle_post_like' => 'users#handle_post_like'
  post 'users/handle_post_dislike' => 'users#handle_post_dislike'

  post 'comments/handle_like' => 'comments#handle_like'
  post 'comments/handle_dislike' => 'comments#handle_dislike'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'main_courses#home'

  resources :users do
    member do
     get :posts_feed
    end
  end
  resources :posts
  resources :comments, except: [:show]


end
