Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/oauth/callback', to: 'data#create_session'
  get '/index', to: 'data#index'
  root to: 'data#index'
end
