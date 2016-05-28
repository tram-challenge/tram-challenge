Rails.application.routes.draw do
  namespace :api do
    resource :player, only: %i(show update)
    resources :stops, only: %i(show index)
    put "stops/:id" => "attempt_stops#update"
    resources :attempts, only: %i(index show create update)
  end

  resources :tram_routes, path: "routes", only: %i(index show)

  root "pages#home"

  get "map" => "pages#map"
end
