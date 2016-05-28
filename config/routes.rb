Rails.application.routes.draw do
  namespace :api do
    resource :player, only: %i(show update)
    resources :stops, only: %i(show index)
    resources :attempts, only: %i(index show create update)
  end

  root "pages#home"
end
