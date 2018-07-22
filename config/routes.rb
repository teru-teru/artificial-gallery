Rails.application.routes.draw do
  root to: "toppages#index"
  
  get "confidence_ranking", to: "images#confidence"
  get "analysis_false", to: "images#analysis_false"
  resources :tags, only: [:show, :index]
  resources :images, only: [:show, :new, :create, :destroy]
end
