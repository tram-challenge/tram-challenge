Rails.application.routes.draw do
  namespace :api do
    resource :player, only: %i(show update)
    resources :stops, only: %i(show index)
    put "stops" => "attempt_stops#update"
    resources :attempts, only: %i(index show create update)
  end

  root "pages#home"

  get "map" => "pages#map"
end
