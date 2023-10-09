Rails.application.routes.draw do
  root   "top_pages#home"

  get    "/main",                                     to: "top_pages#main"
  get    "/how_to_use",                               to: "top_pages#how_to_use"
  get    "/terms_of_use",                             to: "top_pages#terms_of_use"
                
  get    "/login",                                    to: "sessions#new"
  post   "/login",                                    to: "sessions#create"
  delete "/logout",                                   to: "sessions#destroy"


  get "/hole/:id",                                    to: "holes#new",    as: "hole_new"
  post "/holes",                                      to: "holes#create"
  get "/hole/:golf_course_id/edit",                   to: "holes#edit",     as: "hole_edit"
  patch "holes/:golf_course_id",                      to: "holes#update",   as: "hole_update"

  
  resources :golf_courses
  resources :users
end
