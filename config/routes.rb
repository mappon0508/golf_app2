Rails.application.routes.draw do
  root   "top_pages#home"
  get    "/terms_of_use",    to: "terms_of_use#main"
  resources :users
end
