Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :users, except: %i(index, destroy)
  resources :sessions, only: %i(new create destroy)
  namespace :admin do
    resources :users
  end
  resources :labels, except: :show
end
