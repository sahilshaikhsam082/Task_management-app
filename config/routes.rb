Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :tasks, only: [:create] do
    member do
      patch 'complete', to: 'tasks#complete_task'
      post 'assign', to: 'tasks#assign_task'
    end
    collection do
      get 'assigned', to: 'tasks#assigned_tasks'
    end
  end
  post '/api/register', to: 'registrations#create'
  post '/api/login', to: 'authentication#login'
end
