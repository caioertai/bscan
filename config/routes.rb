Rails.application.routes.draw do
  resources :product_ingredients
  resources :ingredients
  resources :products
  resources :search
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'search#search'
  get '/search_by_ean', to: 'search#search_by_ean'
  get '/search_by_name', to: 'search#search_by_name'
  get '/anomalies', to: 'products#anomalies'
end
