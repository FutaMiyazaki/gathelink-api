Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :links, only: %i[index create update destroy]
      get 'health_check', to: 'health_check#index'
    end
  end
end
