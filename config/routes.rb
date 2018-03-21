Rails.application.routes.draw do
  resources :product_ingredients
  resources :ingredients
  resources :products
  resources :pages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#search'
  get '/search/', to: 'pages#search'
  get '/search_by_ean', to: 'pages#search_by_ean'
  get '/search_by_name', to: 'pages#search_by_name'
end
