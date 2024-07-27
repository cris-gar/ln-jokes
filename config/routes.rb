Rails.application.routes.draw do
  resources :jokes
  resources :home
  get 'qr_login' => 'home#qr_login'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "jokes#index"
end
