Rails.application.routes.draw do
  devise_for :admins, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }
  resources :ingredients, :products
  resources :brands, only: %i[index show]

  # Main routes
  root to: 'pages#home'
  get '/search', to: 'search#product_search'

  # Admin Routes
  get '/close_match', to: 'ingredients#close_match'
  get '/anomalies', to: 'products#anomalies'
end
