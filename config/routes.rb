Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :posts, only: [:show, :create, :update, :destroy, :index]
      resources :users, only: [:show, :create, :update, :destroy]
    end
  end
end
