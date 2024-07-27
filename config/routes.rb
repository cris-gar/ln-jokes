Rails.application.routes.draw do
  resources :jokes
  resources :home
  get 'qr_login' => 'home#qr_login'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "jokes#index"
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :users
  get '/users/:id', :to => 'users#edit', :as => :user
  patch '/users/:id', :to => 'users#update'

  namespace :authentication, path: '', as: '' do
    resources :sessions, only: [:destroy]
    get 'auth' => 'sessions#auth'
    get 'login' => 'sessions#login'
  end
end
