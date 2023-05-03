Rails.application.routes.draw do
  require 'sidekiq/web'
  require "sidekiq/cron/web"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # ----------------------------------------------------------------------
  # Monitoring
  scope :monitoring do
    # Sidekiq Basic Auth from routes on production environment
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_AUTH_USERNAME"])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_AUTH_PASSWORD"]))
    end if Rails.env.production?

    mount Sidekiq::Web, at: '/sidekiq'
  end

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
        get 'card_collection/:id/cards', to: 'card_collection#cards'

        resources :card, only: [:create]
        patch 'card/', to: 'card#update'
        delete 'card/', to: 'card#destroy'

        patch 'study_session/:id/study_card/:study_card_id', to: 'study_session#answer_study_card'
        resources :study_session, only: [:create]

        patch 'test_session/:id/test_card/:test_card_id', to: 'test_session#answer_test_card'
        put 'test_session/:id/submit_test/', to: 'test_session#submit_test'
        resources :test_session, only: [:create]
      end
    end
  end

end
