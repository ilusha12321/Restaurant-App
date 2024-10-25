Rails.application.routes.draw do

  get "contact", to: "contact#contact"

  resources :restaurants do
    resources :reviews, only: [:index, :new, :create, :destroy]
  end

  resources :menu, only: [:new, :create, :edit, :update, :destroy, :index]
  get '/menu/:category_id', to: 'menu#category', as: :menu_category

  get 'categories', to: 'categories#index'

  post 'add_to_cart', to: 'items#add_to_cart', as: :add_to_cart

  resource :cart, only: [:show] do
    delete 'clear', on: :collection
    post 'remove_one', on: :collection
  end

  resources :orders, only: [:create, :index, :show]
  patch 'orders/:id/cancel', to: 'orders#cancel', as: :cancel_order
  delete 'orders/:id', to: 'orders#destroy', as: :delete_order
  patch 'orders/:order_id/items/:id/update_quantity', to: 'orders#update_quantity', as: :update_order_item_quantity
  delete 'orders/:order_id/items/:item_id', to: 'orders#destroy_item', as: :delete_order_item
  patch 'orders/:id/update_status', to: 'orders#update_status', as: :update_order_status

  root 'restaurants#index'

  get "password", to: "password#edit", as: "edit_password"
  patch "password", to: "password#update"
  post "password", to: "password#create"


  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"

  delete "logout", to: "sessions#destroy"

  get "password/reset", to: "password_reset#new"
  post "password/reset", to: "password_reset#create"

  get "password/reset/edit", to: "password_reset#edit"
  patch "password/reset/edit", to: "password_reset#update"

  get "profile/edit", to: "profile#edit"
  patch "profile/edit", to: "profile#update"
  post "profile/edit", to: "profile#create"

  match '*path', to: 'restaurants#index', via: :all
end
