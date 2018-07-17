Rails.application.routes.draw do
  root to: "images#new"
  
  resources :images, only: [:show, :new, :create, :destroy]
end
