Rails.application.routes.draw do
  namespace :api do
    resource :player, only: %i(show update)
    resources :stops, only: %i(show index)
  end

  root "pages#home"
end
