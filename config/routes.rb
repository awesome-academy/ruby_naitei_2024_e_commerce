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
      member do
        patch :cancel
      end
    end
    resources :account_activations, only: :edit
    namespace :admin do
      resources :statistics do
        collection do
          get "users_signup"
        end
      end
      resources :categories
      resources :products
      resources :cart_details
      resources :home
      resources :users, only: :index
      resources :bills, only: [:index, :show, :update] do
        member do
          patch :update_status
          patch :update_reason
        end
      end
      resources :vouchers
    end
    namespace :api do
      namespace :v1 do
        resources :bills do
          collection do
            patch :repayment
            patch :update_total
            get :states
            get :cities
          end
        end
        resources :products, only: [:index, :show]

        post "login", to: "sessions#create"
        delete "logout", to: "sessions#destroy"

        namespace :admin do
          resources :bills, only: [:index, :show, :update] do
            patch :update_status, on: :member
          end
          resources :products, only: [:index, :show, :create, :update, :destroy]
        end
        resources :cart, only: [:show, :create, :update, :destroy]
        post "/check_remain_and_redirect", to: "cart#check_remain_and_redirect"
      end
    end
  end
end
