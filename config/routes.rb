Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'sessions#new'
  resources :sessions
  resources :reset_passwords, only: [:new, :create, :edit, :update], param: :token
  resources :users
end
