Rails.application.routes.draw do
  get 'pong' => 'pong#pong'

  resources :authors, only: [:create]
end
