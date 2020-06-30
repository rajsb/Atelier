# frozen_string_literal: true

Rails.application.routes.draw do
  # api namespace
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
    end
  end
end
