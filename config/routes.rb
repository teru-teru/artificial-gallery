Rails.application.routes.draw do
  root to: "toppages#index"
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  
  get "signup", to: "users#new"
  get "confidence_ranking", to: "images#confidence"
  get "analysis_false", to: "images#analysis_false"
  get "images/:id/relevance", to: "images#relevance"

  resources :users, only: [:show, :new, :create]
  resources :tags, only: [:show, :index]
  resources :images, only: [:show, :new, :create, :destroy]
  
  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  
end
