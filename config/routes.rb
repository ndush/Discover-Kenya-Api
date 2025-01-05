Rails.application.routes.draw do
  get "attractions/index"
resources :attractions, only: [:index]
end
