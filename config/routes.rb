Rails.application.routes.draw do
  devise_for :users, only: [:session, :omniauth_callbacks], :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }


  resource :user do
    member do
      post :refresh_api_token
    end
  end
  resources :enviroments
  resources :tasks do
    member do
      post :run
    end
    collection do
      post :import
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
