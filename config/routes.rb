Rails.application.routes.draw do
  resources :webhooks, only: :create
  scope "(:locale)", locale: /en|vi/ do
    post "/check_remain_and_redirect", to: "cart#check_remain_and_redirect"
    root "static_pages#home"
    devise_for :users
    as :user do
      get "signin" => "devise/sessions#new"
      post "signin" => "devise/sessions#create"
      delete "signout" => "devise/sessions#destroy"
    end
    post "bills/repayment", to: "bills#repayment"
    resources :products
    resources :wishlists
    resources :checkout, only: :create
    resources :comments
    resources :cart, only: [:show, :create, :update, :destroy]
    resources :bills do
      patch :update_total, on: :collection
      get :states, on: :collection
      get :cities, on: :collection
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
