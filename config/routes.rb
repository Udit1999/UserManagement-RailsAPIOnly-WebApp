Rails.application.routes.draw do

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      # devise_for :users, skip: [:sessions] 

      resource :sessions, only: [:create, :destroy]
      resource :users, skip: [:edit]
      get '/users/:id', to: 'users#show'
      delete '/users/:id', to: 'users#destroy'
      get '/allusers/', to: 'users#show_all'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
