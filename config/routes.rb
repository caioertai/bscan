Rails.application.routes.draw do
  resources :product_ingredients
  resources :ingredients
  resources :products
  resources :pages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#home'

  get '/search_by_ean/:ean', to: 'pages#home'
end
