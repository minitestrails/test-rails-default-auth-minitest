Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :recipes
  root "recipes#index"
end
