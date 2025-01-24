Rails.application.routes.draw do
  post 'users/login', to: 'users#login'
  post 'users/register', to: 'users#register'
  delete 'users/logout', to: 'users#logout'

  get 'attractions/search', to: 'attractions#search'

  resources :attractions, only: [:index, :create] do
    member do
      patch :approve
      patch :reject
    end
  end
end
