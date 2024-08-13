Rails.application.routes.draw do
  resources :webhooks, only: :create
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  scope "(:locale)", locale: /en|vi/ do
    post "/check_remain_and_redirect", to: "cart#check_remain_and_redirect"
    root "static_pages#home"
    post "checkout/create", to: "checkout#create"
    post "checkout/repayment", to: "checkout#repayment"
    as :user do
      get "signin" => "devise/sessions#new"
      post "signin" => "devise/sessions#create"
      delete "signout" => "devise/sessions#destroy"
    end
    resources :products
    resources :wishlists
    resources :checkout, only: :create
    resources :comments
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
