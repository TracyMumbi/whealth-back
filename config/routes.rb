Rails.application.routes.draw do
  resources :projects
  resources :documents
  resources :appointments
  resources :consultants
  resources :otps, except: [:update]
  resources :users
  post "/confirm-otp", to: "otps#confirm_otp"
  post '/reset_password', to: 'users#reset_password'
  post '/forgot_password', to: 'users#forgot_password'
  post '/login', to: 'users#login'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end