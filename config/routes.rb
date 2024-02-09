Rails.application.routes.draw do
  root   "top_pages#home"

  resources :top_pages, only: [] do
    collection do
      get :main
      get :how_to_use
      get :terms_of_use
    end
  end
                
  resources :sessions, only: [:new, :create], path: "login"
  resource :sessions, only: [:destroy], path: '/logout', as: :logout

  resources :users do
    member do
      get "password_edit", to: "users#edit_password"
    end
    collection do
      patch "update_password", to: "users#update_password"
    end
  end

  resources :holes, only: [] do
    member do
      get :new
    end
  end
  resources :holes, only: [:create, :edit, :update]

  resources :golf_play_records, only: [] do
    member do
      get :new
    end
  end

  resources :scores, only: [] do
    member do
       get :index
      get :new
    end
  end
  resources :scores, only: [:create]
  get "/score/:id/:hole_id/new",                      to: "scores#next_new",         as: "new_scores"

  resources :past_scores, only: [:index]
  resources :practice_days, only: [:new, :create]

  resources :practice_advices, only: [] do
    collection do
      get :create
    end
    member do
      get :index
      get :show, path: :show, as: :show
    end
  end

  resources :practice_advices, only: [:index, :create, :show]

  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :practice_menus
  resources :scores,  except: [:new,:create, :index]
  resources :golf_play_records,  except: [:new]
  resources :golf_courses
  resources :users
end