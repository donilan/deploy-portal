Rails.application.routes.draw do
  devise_for :users, only: [:session]

  resource :user do
    member do
      post :refresh_api_token
    end
  end
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
end
