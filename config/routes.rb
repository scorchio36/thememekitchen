Rails.application.routes.draw do
  get '/home', to: 'static_pages#home'

  get '/buffet', to: 'static_pages#buffet'

  get '/kitchen', to: 'static_pages#kitchen'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'static_pages#home' 

end
