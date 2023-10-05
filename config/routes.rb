Rails.application.routes.draw do
  root   "top_pages#home"

  get    "/main",                     to: "top_pages#main"
  get    "/how_to_use",               to: "top_pages#how_to_use"
  get    "/terms_of_use",             to: "top_pages#terms_of_use"

  get    "/login",                    to: "sessions#new"
  post   "/login",                    to: "sessions#create"
  delete "/logout",                   to: "sessions#destroy"

  get   "/golf_course_search",        to: "golf_courses#search"
  get   "/golf_course/:id",   to: "golf_courses#setting",  as: "golf_course_setting"
  resources :users
end
