# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'tweets#index'
  resource :map, only: %i[show]
  resources :locations, only: %i[index]
  resources :tweets, only: %i[index]
end
