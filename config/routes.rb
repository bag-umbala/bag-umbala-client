Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/oauth/callback', to: 'data#create_session'
  get '/oauth/logout', to: 'data#destroy_session'
  get '/index', to: 'data#index'
  get '/test', to: 'data#test'
  root to: 'data#index'
end
