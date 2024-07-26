Rails.application.routes.draw do
  resources :products
  scope "(:locale)", locale: /en|vi/ do
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users, only: %i(new create show)
    resources :account_activations, only: :edit
  end
end
