Rails.application.routes.draw do
  root to: "images#new"
  
  get "confidence_ranking", to: "images#confidence"
  resources :tags, only: [:show, :index]
  resources :images, only: [:show, :new, :create, :destroy]
end
