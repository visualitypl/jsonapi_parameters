Rails.application.routes.draw do
  get 'pong' => 'pong#pong'

  post :stack_default, controller: 'stack_tester'
  post :stack_custom_limit, controller: 'stack_tester'
  post :short_stack_custom_limit, controller: 'stack_tester'

  resources :authors, only: [:create, :update]
  resources :authors_deprecated_to_jsonapi, only: [:create]
  resources :authors_camel, only: [:create]
  resources :authors_dashed, only: [:create]
end
