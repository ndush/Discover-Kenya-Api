Rails.application.routes.draw do
  # User routes
  post 'users/login', to: 'users#login'
  post 'users/register', to: 'users#register'
  delete 'users/logout', to: 'users#logout'

  # Attraction routes
  get 'attractions/search', to: 'attractions#search'
  get 'attractions/search_by_location', to: 'attractions#search_by_location'
  get 'attractions/search_by_name_and_location', to: 'attractions#search_by_name_and_location'

  resources :attractions, only: [:index, :create] do
    member do
      patch :approve
      patch :reject
    end
  end
end
