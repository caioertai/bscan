Rails.application.routes.draw do
  resources :product_ingredients
  resources :ingredients
  resources :products
  resources :search
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'search#search'
  get '/by_ean', to: 'search#by_ean'
  get '/by_name', to: 'search#by_name'
  get '/close_match', to: 'search#close_match'
  get '/anomalies', to: 'products#anomalies'
end
