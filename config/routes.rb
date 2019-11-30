# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'dashboard#index'
  resources :locations, only: %i[index]
end
