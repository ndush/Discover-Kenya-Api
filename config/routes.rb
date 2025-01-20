Rails.application.routes.draw do
  # Devise routes for users, including JWT-based authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'  # Ensure this is for JWT handling if necessary
  }

  # Custom registration route (if needed)
  post 'users/register', to: 'users/registrations#create'

  # Route for JWT-based logout (revocation)
  delete 'logout', to: 'users/sessions#destroy'  # Ensure your SessionsController handles JWT revocation

  # Attractions routes with approve and reject actions
  resources :attractions, only: [:index, :create] do
    member do
      patch :approve
      patch :reject
    end
  end
end
