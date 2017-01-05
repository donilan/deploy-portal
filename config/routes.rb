Rails.application.routes.draw do
  devise_for :users, only: [:session, :omniauth_callbacks, :passwords],
             :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users do
    collection do
      post :refresh_api_token
      patch :update_password
      get :myaccount
    end
    member do
      post :reset_password
      post :lock
      post :unlock
    end
  end

  resources :env_groups
  resources :settings, only: [:index, :update, :edit]
  resources :tasks do
    member do
      post :run
    end
    collection do
      post :import
      post :import_from_url
    end
    resources :jobs, only: [:show, :index, :create] do
      member do
        get :trace
      end
    end
  end
  root to: redirect('tasks')

  namespace :api do
    get 'tasks/:id/run' => 'tasks#run', as: 'tasks_run'
  end
end
