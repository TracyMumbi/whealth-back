Rails.application.routes.draw do
  resources :growths
  resources :transactions, only: [:show, :create, :index] do
    member do
      get 'query', action: :query
    end
  end
  resources :payments
  resources :notifications
  resources :quills
  resources :projects
  resources :documents
  resources :appointments
  resources :consultants
  resources :otps, except: [:update]
  resources :users
  post "/confirm-otp", to: "otps#confirm_otp"
  post '/reset_password', to: 'users#reset_password'
  post '/forgot_password', to: 'users#forgot_password'
  post "/login", to: "sessions#create"
  get "/all-projects", to: "projects#all"
  post '/stk_push', to: 'payments#stk_push'
  get 'growths/user/:user_id', to: 'growths#user_growths'
  get '/projects/:project_id/appointments', to: 'appointments#index'  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  mount ActionCable.server => '/cable', constraints: -> (request) {
    user_role = request.headers['Role']

    case user_role
    when 'Consultant'
      ConsultantChannel
    when 'User'
      UsersChannel
    end
    
    channel_class || ActionCable.server.config.cable[:channel_class].reject_unauthorized_connection
  }

end
