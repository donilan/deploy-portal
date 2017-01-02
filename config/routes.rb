Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'tasks#index'
  resources :tasks do
    resources :jobs, only: [:show, :index, :create] do
      member do
        get :trace
      end
    end
    member do
      post :run
    end
  end
end
