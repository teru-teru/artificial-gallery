Rails.application.routes.draw do
  root to: "images#new"
  resources :tags, only: [:show]
  resources :images, only: [:show, :new, :create, :destroy]
end
