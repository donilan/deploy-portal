Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

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
