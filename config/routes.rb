# frozen_string_literal: true

Rails.application.routes.draw do
  # api namespace
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[show create update destroy]
      resources :tokens, only: [:create]
    end
  end
end
