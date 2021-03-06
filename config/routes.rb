Rails.application.routes.draw do
  root to: 'top#index'
  get "example", to: "top#example"
  devise_for :users, controllers: {
    sessions: 'users/sessions',
  }
  devise_scope :user do
    get '/callback', to: 'users/sessions#callback'
    get "openid", to: "users/sessions#openid"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
