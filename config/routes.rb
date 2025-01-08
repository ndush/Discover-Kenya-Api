Rails.application.routes.draw do
  # Devise routes for users, including session management for JWT
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Custom route for user registration (if needed)
  post 'users/register', to: 'users/registrations#create'

  # Attractions routes with approve and reject actions
  resources :attractions, only: [:index, :create] do
    member do
      patch :approve
      patch :reject
    end
  end
end
