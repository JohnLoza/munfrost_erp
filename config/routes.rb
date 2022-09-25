Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: redirect("/users/sign_in")

  devise_for :users
  resources :inventory_files, only: [:index, :create]
end
