Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "sessions/new"
    get "sessions/create"
    get "sessions/destroy"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    root "static_pages#home"
    resources :products
    resources :users
    resources :account_activations, only: :edit
    namespace :admin do
      resources :categories
      resources :home
    end
  end
end
