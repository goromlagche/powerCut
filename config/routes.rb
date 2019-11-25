# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'dashboard#index'
  resources :geo_json, only: %i[index]
end
