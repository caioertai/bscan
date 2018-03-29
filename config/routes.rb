Rails.application.routes.draw do
  resources :ingredients, :products
  # resources :search
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#home'
  get '/close_match', to: 'search#close_match'
  get '/product_search', to: 'search#product_search'
  get '/anomalies', to: 'products#anomalies'
end
