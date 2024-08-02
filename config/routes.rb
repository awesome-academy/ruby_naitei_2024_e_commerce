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
    get "/logout", to: "sessions#destroy"
    post "/check_remain_and_redirect", to: "cart#check_remain_and_redirect"
    root "static_pages#home"
    post "checkout/create", to: "checkout#create"
    post "checkout/repayment", to: "checkout#repayment"
    resources :products
    resources :wishlists
    resources :checkout, only: :create
    resources :users
    resources :cart, only: [:show, :create, :update, :destroy]
    resources :bills do
      patch :update_total, on: :collection
    end
    resources :account_activations, only: :edit
    namespace :admin do
      resources :categories
      resources :products
      resources :cart_details
      resources :home
      resources :users, only: :index
      resources :bills, only: [:index, :show, :update] do
        member do
          patch :update_status
        end
      end
      resources :vouchers
    end
  end
end
