Rails.application.routes.draw do
  get 'pong' => 'pong#pong'

  resources :authors, only: [:create, :update]
  resources :authors_deprecated_to_jsonapi, only: [:create]
  resources :authors_camel, only: [:create]
  resources :authors_dashed, only: [:create]
end
