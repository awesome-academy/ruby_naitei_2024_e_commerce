Rails.application.routes.draw do
  resources :webhooks, only: :create
  scope "(:locale)", locale: /en|vi/ do
    get "sessions/new"
    get "sessions/create"
    get "sessions/destroy"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/cart", to: "cart#show"
    post "/cart/create"
    post "/check_remain_and_redirect", to: "cart#check_remain_and_redirect"
    root "static_pages#home"
    post "checkout/create", to: "checkout#create"
    resources :carts
    resources :products
    resources :wishlists
    resources :checkout, only: :create
    resources :users
    resources :bills do
      patch :update_total, on: :collection
    end
    resources :account_activations, only: :edit
    namespace :admin do
      resources :categories
      resources :home
      resources :products
      resources :bills, only: [:index, :show]
      resources :cart_details
    end
  end
end
