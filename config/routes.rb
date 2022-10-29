Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        sessions: "api/v1/auth/sessions"
      }
      devise_scope :api_v1_user do
        post "auth/guest_sign_in", to: "auth/sessions#guest_sign_in"
      end
      resources :folders, only: %i[index show create update destroy]
      get "my_folder_list", to: "folders#my_folder_list"
      resources :folder_favorites, only: %i[create destroy]
      resources :links, only: %i[index show create update destroy]
      get "health_check", to: "health_check#index"
    end
  end
end
