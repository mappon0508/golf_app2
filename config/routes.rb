Rails.application.routes.draw do
  root   "top_pages#home"

  get    "/main",                                     to: "top_pages#main"
  get    "/how_to_use",                               to: "top_pages#how_to_use"
  get    "/terms_of_use",                             to: "top_pages#terms_of_use"
                
  get    "/login",                                    to: "sessions#new"
  post   "/login",                                    to: "sessions#create"
  delete "/logout",                                   to: "sessions#destroy"


  get "/hole/:id",                                    to: "holes#new",               as: "hole_new"
  post "/holes",                                      to: "holes#create"  
  get "/hole/:golf_course_id/edit",                   to: "holes#edit",              as: "hole_edit"
  patch "holes/:golf_course_id",                      to: "holes#update",            as: "hole_update"
  
  get "/golf_play_records/:id/new",                   to: "golf_play_records#new",   as: "new_golf_play_record"
  
  get "/score/:id/new",                               to: "scores#new",              as: "new_score"
  get "/score/:id/:hole_id/new",                      to: "scores#next_new",         as: "new_scores"
  post "/score/create",                               to: "scores#create",           as: "create_score"
  get "/scores/:id/",                                 to: "scores#index",            as: "scores"
  
  get "/past_scores",                                 to: "past_scores#index"

  get "/practice_days/new",                           to: "practice_days#new"
  post "/practice_days",                              to: "practice_days#create",    as: "practice_days"

  get "/practice_advice",                             to: "practice_advices#create", as: "practice_advice"

  get "/practice_advices/:id",                        to: "practice_advices#index",  as: "practice_advices"
  get "/practice_advices/show/:id",                   to: "practice_advices#show",  as: "practice_advice_show"
  

  resources :practice_menus
  resources :scores,  except: [:new,:create, :index]
  resources :golf_play_records,  except: [:new]
  resources :golf_courses
  resources :users
end
