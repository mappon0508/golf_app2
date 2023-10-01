Rails.application.routes.draw do
  root   "top_pages#home"
  get    "/how_to_use",   to: "top_pages#how_to_use"
  get    "/terms_of_use",    to: "terms_of_use#main"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  resources :users
end
