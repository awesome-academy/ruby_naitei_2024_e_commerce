Rails.application.routes.draw do
  resources :products
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  scope "(:locale)", locale: /en|vi/ do
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    resources :users, only: %i(new create show)
    resources :account_activations, only: :edit
  end
end
