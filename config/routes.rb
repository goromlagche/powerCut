# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'dashboard#index'
  resource :map, only: %i[show]
  resources :locations, only: %i[index]
end
