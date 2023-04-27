Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root to: ->(_) { [400, {}, ["please contact administrator!"]] }
  post 'authentication/login', to: 'authentication#login'
  post 'authentication/login_token', to: 'authentication#login_token'
  post 'authentication/logout', to: 'authentication#logout'
  post 'authentication/forgot_password', to: 'authentication#forgot_password'
  post 'authentication/forgot_password_with_email', to: 'authentication#forgot_password_with_email'
  post 'authentication/change_password_with_token', to: 'authentication#change_password_with_token'
  get 'authentication/auth_verify', to: 'authentication#auth_verify'

  namespace :api, as: '' do
    namespace :v1, as: '' do
      namespace :workplace, as: '' do
        get 'dashboard/', to: 'dashboard#index'
        resources :card_collection, only: [:index, :show, :create, :update, :destroy]
        # get 'card_collection/:id/cards', to: 'card_collection#cards'
      end
    end
  end

end
