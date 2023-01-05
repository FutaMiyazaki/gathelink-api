Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        sessions: "api/v1/auth/sessions"
      }
      devise_scope :api_v1_user do
        post "auth/guest_sign_in", to: "auth/sessions#guest_sign_in"
        get "auth/show_current_user", to: "auth/sessions#show_current_user"
      end

      resources :folders, only: %i[show create update destroy]
      get "my_folders", to: "folders#my_folders"
      get "favorite_folders", to: "folders#favorite_folders"
      resources :folder_favorites, only: %i[create destroy]

      resources :links, only: %i[show create update destroy]
      get "my_links", to: "links#my_links"

      get "health_check", to: "health_check#index"
    end
  end
end
